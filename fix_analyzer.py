#!/usr/bin/env python3
# fix_analyzer.py - تحليل أخطاء مشروع Flutter وتشخيص سبب الخروج

import os
import re
import subprocess
import sys
from pathlib import Path
from datetime import datetime

class FlutterProjectAnalyzer:
    def __init__(self, project_path):
        self.project_path = Path(project_path)
        self.errors = []
        self.warnings = []
        self.missing_files = []
        self.wrong_imports = []
        
    def run(self):
        print("=" * 60)
        print("🔍 Zion OS - Flutter Project Analyzer")
        print("=" * 60)
        print(f"📁 Project Path: {self.project_path}")
        print(f"📅 Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 60)
        
        self.check_imports()
        self.check_missing_files()
        self.check_pubspec()
        self.check_android_config()
        self.check_main_dart()
        self.check_responsive_desktop()
        self.check_icon_errors()
        self.generate_report()
        
    def check_imports(self):
        print("\n📋 1. فحص الاستيرادات (imports)...")
        main_dart = self.project_path / "lib" / "main.dart"
        
        if not main_dart.exists():
            self.errors.append("main.dart غير موجود!")
            return
            
        content = main_dart.read_text()
        import_lines = re.findall(r"import\s+['\"]([^'\"]+)['\"]", content)
        
        for imp in import_lines:
            if imp.startswith('package:'):
                if 'project_zion' in imp:
                    local_path = imp.replace('package:project_zion/', 'lib/')
                    full_path = self.project_path / local_path
                    if not full_path.exists():
                        self.wrong_imports.append(imp)
                        print(f"   ❌ استيراد خاطئ: {imp}")
                    else:
                        print(f"   ✅ {imp}")
                else:
                    print(f"   📦 {imp} (مكتبة خارجية)")
            else:
                full_path = self.project_path / imp
                if not full_path.exists():
                    self.wrong_imports.append(imp)
                    print(f"   ❌ ملف غير موجود: {imp}")
                else:
                    print(f"   ✅ {imp}")
                    
    def check_missing_files(self):
        print("\n📁 2. فحص الملفات المهمة...")
        
        important_files = [
            "lib/main.dart",
            "lib/cosmic_terminal.dart",
            "lib/src/features/desktop/responsive_desktop.dart",
            "lib/src/features/splash/splash_screen.dart",
            "lib/src/features/onboarding/onboarding_screen.dart",
            "lib/src/features/lock/lock_screen.dart",
            "lib/src/features/settings/main_settings.dart",
            "pubspec.yaml",
            "android/app/build.gradle",
            "android/build.gradle",
        ]
        
        for file in important_files:
            full_path = self.project_path / file
            if full_path.exists():
                size = full_path.stat().st_size
                print(f"   ✅ {file} ({size} bytes)")
            else:
                self.missing_files.append(file)
                print(f"   ❌ {file} - مفقود!")
                
    def check_pubspec(self):
        print("\n📦 3. فحص pubspec.yaml...")
        pubspec = self.project_path / "pubspec.yaml"
        
        if not pubspec.exists():
            self.errors.append("pubspec.yaml غير موجود")
            return
            
        content = pubspec.read_text()
        
        deps = re.findall(r"^\s+(\w+):\s+\^?([\d\.]+)", content, re.MULTILINE)
        for dep, version in deps:
            print(f"   📦 {dep}: {version}")
            
        assets = re.findall(r"^\s+-\s+(.+)", content, re.MULTILINE)
        if assets:
            print(f"   🖼️ الأصول: {len(assets)} مجلد/ملف")
            
    def check_android_config(self):
        print("\n🤖 4. فحص إعدادات Android...")
        
        build_gradle = self.project_path / "android/app/build.gradle"
        if build_gradle.exists():
            content = build_gradle.read_text()
            
            match = re.search(r"applicationId\s+['\"]([^'\"]+)['\"]", content)
            if match:
                print(f"   📱 applicationId: {match.group(1)}")
                
            match = re.search(r"minSdk\s+(\d+)", content)
            if match:
                print(f"   📱 minSdk: {match.group(1)}")
                
            match = re.search(r"targetSdk\s+(\d+)", content)
            if match:
                print(f"   📱 targetSdk: {match.group(1)}")
                
        manifest = self.project_path / "android/app/src/main/AndroidManifest.xml"
        if manifest.exists():
            content = manifest.read_text()
            if 'package="com.project.zion"' in content:
                print("   ✅ package name: com.project.zion")
            elif 'package="com.example.project_zion"' in content:
                print("   ✅ package name: com.example.project_zion")
            else:
                print("   ⚠️ package name غير قياسي")
                
    def check_main_dart(self):
        print("\n📄 5. فتح main.dart...")
        main_dart = self.project_path / "lib/main.dart"
        
        if not main_dart.exists():
            return
            
        content = main_dart.read_text()
        
        routes = re.findall(r"['\"]/(\w+)['\"]:\s*\(context\)\s*=>\s*const\s+(\w+)\(\)", content)
        if routes:
            print(f"   🧭 المسارات المحددة: {len(routes)}")
            for route, widget in routes[:10]:
                print(f"      /{route} → {widget}")
                
        imports = re.findall(r"import\s+'([^']+)'", content)
        print(f"   📥 استيرادات: {len(imports)}")
        
    def check_responsive_desktop(self):
        print("\n🖥️ 6. فحص responsive_desktop.dart...")
        desktop = self.project_path / "lib/src/features/desktop/responsive_desktop.dart"
        
        if not desktop.exists():
            self.errors.append("responsive_desktop.dart غير موجود")
            return
            
        content = desktop.read_text()
        
        icons = re.findall(r"Icons\.([a-zA-Z_]+)", content)
        if icons:
            print(f"   🎨 أيقونات مستخدمة: {len(set(icons))}")
            
        routes = re.findall(r"AppRoutes\.([a-zA-Z_]+)", content)
        if routes:
            print(f"   🧭 مسارات مستخدمة: {len(set(routes))}")
            
    def check_icon_errors(self):
        print("\n🎨 7. فحص الأيقونات الشائعة المفقودة...")
        
        known_issues = {
            'invisibility': 'visibility_off',
            'snowflake': 'ac_unit',
            'package': 'archive',
            'windows': 'computer',
            'docker': 'developer_board',
            'firewall': 'security',
            'layer': 'layers',
            'screen': 'screenshot',
            'emerald': 'eco',
            'earthquake': 'warning',
            'quality': 'verified',
            'tree': 'account_tree',
        }
        
        for dart_file in self.project_path.rglob("*.dart"):
            try:
                content = dart_file.read_text()
                for wrong, correct in known_issues.items():
                    if f"Icons.{wrong}" in content:
                        print(f"   ⚠️ في {dart_file.name}: Icons.{wrong} → استخدم Icons.{correct}")
            except:
                pass
                
    def generate_report(self):
        print("\n" + "=" * 60)
        print("📊 تقرير التحليل النهائي")
        print("=" * 60)
        
        if self.missing_files:
            print(f"\n❌ ملفات مفقودة ({len(self.missing_files)}):")
            for f in self.missing_files[:10]:
                print(f"   - {f}")
                
        if self.wrong_imports:
            print(f"\n⚠️ استيرادات خاطئة ({len(self.wrong_imports)}):")
            for imp in self.wrong_imports[:10]:
                print(f"   - {imp}")
                
        if self.errors:
            print(f"\n🔴 أخطاء ({len(self.errors)}):")
            for err in self.errors:
                print(f"   - {err}")
                
        print("\n💡 التوصيات:")
        if self.wrong_imports:
            print("   1. قم بتصحيح مسارات الاستيراد في main.dart")
        if self.missing_files:
            print("   2. أعد إنشاء الملفات المفقودة")
            
        print("\n✅ فحص الأخطاء في main.dart:")
        print("   flutter analyze lib/main.dart")
        print("\n✅ فحص الأخطاء في المشروع بالكامل:")
        print("   flutter analyze")
        
        print("\n" + "=" * 60)
        print("🏁 انتهى التحليل")
        print("=" * 60)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        project_path = sys.argv[1]
    else:
        project_path = "/data/data/com.termux/files/home/downloads/Supernova/project_zion"
    
    analyzer = FlutterProjectAnalyzer(project_path)
    analyzer.run()
