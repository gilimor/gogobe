#!/usr/bin/env python3
"""
Quality Assurance Check - Pre-PR Validation
Tests all new features before submission
"""

import requests
import time
from pathlib import Path

API_BASE = 'http://localhost:8000'
FRONTEND_PATH = Path('frontend')

class QATest:
    def __init__(self):
        self.passed = []
        self.failed = []
        
    def test(self, name, func):
        """Run a test"""
        try:
            func()
            self.passed.append(name)
            print(f"✅ {name}")
            return True
        except Exception as e:
            self.failed.append((name, str(e)))
            print(f"❌ {name}: {e}")
            return False
    
    def report(self):
        """Print test report"""
        print("\n" + "="*60)
        print("QUALITY ASSURANCE REPORT")
        print("="*60)
        print(f"✅ Passed: {len(self.passed)}")
        print(f"❌ Failed: {len(self.failed)}")
        print(f"Total: {len(self.passed) + len(self.failed)}")
        
        if self.failed:
            print("\n❌ Failed Tests:")
            for name, error in self.failed:
                print(f"  - {name}: {error}")
        
        print("="*60)
        return len(self.failed) == 0

def main():
    qa = QATest()
    
    print("="*60)
    print("🔍 QUALITY ASSURANCE CHECK")
    print("="*60)
    print()
    
    # Wait for API
    print("⏳ Waiting for API...")
    time.sleep(2)
    
    # 1. File Existence Tests
    print("\n📁 FILE EXISTENCE TESTS:")
    qa.test("dashboard.html exists", lambda: assert_file_exists('frontend/dashboard.html'))
    qa.test("categories.html exists", lambda: assert_file_exists('frontend/categories.html'))
    qa.test("common.js exists", lambda: assert_file_exists('frontend/common.js'))
    qa.test("stores.html exists", lambda: assert_file_exists('frontend/stores.html'))
    qa.test("errors.html exists", lambda: assert_file_exists('frontend/errors.html'))
    qa.test("index.html exists", lambda: assert_file_exists('frontend/index.html'))
    
    # 2. API Endpoint Tests
    print("\n🌐 API ENDPOINT TESTS:")
    qa.test("GET /dashboard.html", lambda: assert_endpoint('/dashboard.html'))
    qa.test("GET /categories.html", lambda: assert_endpoint('/categories.html'))
    qa.test("GET /stores.html", lambda: assert_endpoint('/stores.html'))
    qa.test("GET /errors.html", lambda: assert_endpoint('/errors.html'))
    qa.test("GET /", lambda: assert_endpoint('/'))
    
    # 3. API Data Tests
    print("\n📊 API DATA TESTS:")
    qa.test("GET /api/stats", lambda: assert_api_json('/api/stats'))
    qa.test("GET /api/categories", lambda: assert_api_json('/api/categories'))
    qa.test("GET /api/chains", lambda: assert_api_json('/api/chains'))
    qa.test("GET /api/stores", lambda: assert_api_json('/api/stores'))
    qa.test("GET /api/products/search", lambda: assert_api_json('/api/products/search'))
    
    # 4. Content Tests
    print("\n📝 CONTENT TESTS:")
    qa.test("Dashboard has navigation", lambda: assert_content_contains('/dashboard.html', 'main-nav'))
    qa.test("Dashboard has stats", lambda: assert_content_contains('/dashboard.html', 'total-products'))
    qa.test("Categories has navigation", lambda: assert_content_contains('/categories.html', 'main-nav'))
    qa.test("Index has navigation", lambda: assert_content_contains('/', 'main-nav'))
    
    # Generate Report
    success = qa.report()
    
    if success:
        print("\n🎉 ALL TESTS PASSED! Ready for PR.")
    else:
        print("\n⚠️  SOME TESTS FAILED! Fix before PR.")
    
    return success

def assert_file_exists(path):
    """Check if file exists"""
    if not Path(path).exists():
        raise AssertionError(f"File not found: {path}")

def assert_endpoint(endpoint):
    """Check if endpoint returns 200"""
    response = requests.get(f"{API_BASE}{endpoint}", timeout=5)
    if response.status_code != 200:
        raise AssertionError(f"Status {response.status_code}")

def assert_api_json(endpoint):
    """Check if API endpoint returns valid JSON"""
    response = requests.get(f"{API_BASE}{endpoint}", timeout=5)
    if response.status_code != 200:
        raise AssertionError(f"Status {response.status_code}")
    data = response.json()
    if not data:
        raise AssertionError("Empty response")

def assert_content_contains(endpoint, text):
    """Check if page contains text"""
    response = requests.get(f"{API_BASE}{endpoint}", timeout=5)
    if response.status_code != 200:
        raise AssertionError(f"Status {response.status_code}")
    if text not in response.text:
        raise AssertionError(f"Content missing: {text}")

if __name__ == "__main__":
    try:
        success = main()
        exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ QA TEST FAILED: {e}")
        exit(1)

