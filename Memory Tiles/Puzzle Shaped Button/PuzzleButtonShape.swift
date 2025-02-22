//
//  PuzzleButtonShape.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI

/// A puzzle-piece shape that:
/// - Has rounded corners (cornerRadius)
/// - Has a cave (indentation) in the center of the top and bottom edges
/// - Has a protrusion (tab) in the center of the left and right edges
struct PuzzlePieceButtonShape: Shape {
    var cornerRadius: CGFloat = 10
    var arcRadius: CGFloat = 10        // The half-arc for caves/tabs width
    var caveDepth: CGFloat = 15        // How deep the top/bottom indent goes
    var protrusionDepth: CGFloat = 15  // How far the left/right tabs stick out
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        
        // Constrain parameters to avoid overshooting the shape.
        let cr = min(cornerRadius, w/2, h/2)
        let ar = min(arcRadius, w/4, h/4)
        let cDepth = min(caveDepth, h/2)
        let pDepth = min(protrusionDepth, w/2)
        
        var path = Path()
        
        // 1) Top-left corner arc.
        path.move(to: CGPoint(x: cr, y: 0))
        path.addArc(center: CGPoint(x: cr, y: cr),
                    radius: cr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: -180),
                    clockwise: true)
        
        // 2) Move along the top edge to the start of the top cave.
        path.addLine(to: CGPoint(x: w/2 - ar, y: 0))
        
        // Top cave dips downward. The control point is inside the shape (y = +cDepth).
        path.addQuadCurve(
            to: CGPoint(x: w/2 + ar, y: 0),
            control: CGPoint(x: w/2, y: cDepth)
        )
        
        // Continue to top-right corner arc.
        path.addLine(to: CGPoint(x: w - cr, y: 0))
        path.addArc(center: CGPoint(x: w - cr, y: cr),
                    radius: cr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        // 3) Right edge tab (protrusion).
        path.addLine(to: CGPoint(x: w, y: h/2 - ar))
        // Protrusion arcs outward to the right. The control point is at x = w + pDepth.
        path.addQuadCurve(
            to: CGPoint(x: w, y: h/2 + ar),
            control: CGPoint(x: w + pDepth, y: h/2)
        )
        
        // Down to bottom-right corner arc.
        path.addLine(to: CGPoint(x: w, y: h - cr))
        path.addArc(center: CGPoint(x: w - cr, y: h - cr),
                    radius: cr,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        // 4) Bottom cave (indentation).
        path.addLine(to: CGPoint(x: w/2 + ar, y: h))
        // Cave dips upward inside the shape (control point at y = h - cDepth).
        path.addQuadCurve(
            to: CGPoint(x: w/2 - ar, y: h),
            control: CGPoint(x: w/2, y: h - cDepth)
        )
        
        // Continue to bottom-left corner arc.
        path.addLine(to: CGPoint(x: cr, y: h))
        path.addArc(center: CGPoint(x: cr, y: h - cr),
                    radius: cr,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        // 5) Left edge tab (protrusion).
        path.addLine(to: CGPoint(x: 0, y: h/2 + ar))
        // Protrusion arcs outward to the left. The control point is x = -pDepth.
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h/2 - ar),
            control: CGPoint(x: -pDepth, y: h/2)
        )
        
        // Finally, back to top-left corner arc.
        path.addLine(to: CGPoint(x: 0, y: cr))
        
        path.closeSubpath()
        return path
    }
}




