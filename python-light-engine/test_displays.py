#!/usr/bin/env python3
"""
IMOL Display Detection Test
============================
Quick script to verify which displays are detected and how they'll be assigned.
Run this before setting up auto-start to confirm your display configuration.
"""

import sys
from PySide6.QtWidgets import QApplication

def main():
    print("=" * 60)
    print("IMOL Display Detection Test")
    print("=" * 60)
    print()
    
    app = QApplication(sys.argv)
    screens = app.screens()
    
    print(f"Total displays detected: {len(screens)}")
    print()
    
    if len(screens) == 0:
        print("❌ ERROR: No displays detected!")
        return 1
    
    # Show all displays
    print("All displays:")
    print("-" * 60)
    for i, screen in enumerate(screens):
        size = screen.size()
        geom = screen.geometry()
        avail = screen.availableGeometry()
        is_primary = (screen == app.primaryScreen())
        
        print(f"Display {i}: {screen.name()}")
        print(f"  Size: {size.width()}x{size.height()} pixels")
        print(f"  Position: ({geom.x()}, {geom.y()})")
        print(f"  Available area: {avail.width()}x{avail.height()}")
        print(f"  Primary: {'✓ YES' if is_primary else '  No'}")
        print(f"  Refresh rate: {screen.refreshRate():.1f} Hz")
        print()
    
    # Auto-detection logic
    if len(screens) > 1:
        print("Auto-detection assignments:")
        print("-" * 60)
        
        # Score: largest screen
        largest = max(screens, key=lambda s: s.size().width() * s.size().height())
        largest_idx = screens.index(largest)
        largest_size = largest.size()
        largest_area = largest_size.width() * largest_size.height()
        
        print(f"📽️  SCORE APP → Display {largest_idx} ({largest.name()})")
        print(f"   Resolution: {largest_size.width()}x{largest_size.height()}")
        print(f"   Area: {largest_area:,} pixels²")
        print(f"   (Largest screen - assumed to be projector)")
        print()
        
        # Controller: smallest screen
        smallest = min(screens, key=lambda s: s.size().width() * s.size().height())
        smallest_idx = screens.index(smallest)
        smallest_size = smallest.size()
        smallest_area = smallest_size.width() * smallest_size.height()
        
        print(f"🎛️  CONTROLLER → Display {smallest_idx} ({smallest.name()})")
        print(f"   Resolution: {smallest_size.width()}x{smallest_size.height()}")
        print(f"   Area: {smallest_area:,} pixels²")
        print(f"   (Smallest screen - assumed to be laptop)")
        print()
        
        if largest_idx == smallest_idx:
            print("⚠️  WARNING: Both apps assigned to same display!")
            print("   This means all displays are the same size.")
            print("   Use explicit --display flags in launcher script.")
            print()
    else:
        print("Single display mode:")
        print("-" * 60)
        print("Both apps will use the same display.")
        print("Connect external display/projector for multi-screen setup.")
        print()
    
    # Recommendations
    print("Recommendations:")
    print("-" * 60)
    
    if len(screens) > 1:
        largest = max(screens, key=lambda s: s.size().width() * s.size().height())
        smallest = min(screens, key=lambda s: s.size().width() * s.size().height())
        largest_idx = screens.index(largest)
        smallest_idx = screens.index(smallest)
        
        if largest_idx != smallest_idx:
            print("✅ Auto-detection will work correctly!")
            print(f"   Score → Display {largest_idx} (projector)")
            print(f"   Controller → Display {smallest_idx} (laptop)")
            print()
            print("Use launcher script with default settings:")
            print("   ./start_imol_gallery.sh")
        else:
            print("⚠️  Displays are same size - use explicit flags:")
            print()
            print("Edit start_imol_gallery.sh:")
            print(f"   Score: --display {0 if largest_idx == 1 else 1}")
            print(f"   Controller: --display {1 if largest_idx == 0 else 0}")
    else:
        print("ℹ️  Connect projector/external display for gallery setup")
    
    print()
    print("=" * 60)
    print("Test complete!")
    print("=" * 60)
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
