//
//  PuzzleButtonShape.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI


struct PuzzlePieceButtonShape: Shape {
    var cornerRadius: CGFloat = 10
    var arcRadius: CGFloat = 10
    var caveDepth: CGFloat = 15
    var protrusionDepth: CGFloat = 15
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        
        // Constrain parameters to avoid overshooting the shape.
        let cr = min(cornerRadius, w/2, h/2)
        let ar = min(arcRadius, w/4, h/4)
        let cDepth = min(caveDepth, h/2)
        let pDepth = min(protrusionDepth, w/2)
        
        var path = Path()
        
        // Top-left corner arc.
        path.move(to: CGPoint(x: cr, y: 0))
        path.addArc(center: CGPoint(x: cr, y: cr),
                    radius: cr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: -180),
                    clockwise: true)
        
        
        path.addLine(to: CGPoint(x: w/2 - ar, y: 0))
        
        // Top cave dips downward
        path.addQuadCurve(
            to: CGPoint(x: w/2 + ar, y: 0),
            control: CGPoint(x: w/2, y: cDepth)
        )
        
        // Top-right corner arc.
        path.addLine(to: CGPoint(x: w - cr, y: 0))
        path.addArc(center: CGPoint(x: w - cr, y: cr),
                    radius: cr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        // Right edge protrusion
        path.addLine(to: CGPoint(x: w, y: h/2 - ar))
        // Protrusion arcs outward to the right. The control point is at x = w + pDepth.
        path.addQuadCurve(
            to: CGPoint(x: w, y: h/2 + ar),
            control: CGPoint(x: w + pDepth, y: h/2)
        )
        
        // Bottom-right corner arc.
        path.addLine(to: CGPoint(x: w, y: h - cr))
        path.addArc(center: CGPoint(x: w - cr, y: h - cr),
                    radius: cr,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        // Bottom indentation.
        path.addLine(to: CGPoint(x: w/2 + ar, y: h))
        
        path.addQuadCurve(
            to: CGPoint(x: w/2 - ar, y: h),
            control: CGPoint(x: w/2, y: h - cDepth)
        )
        
        // Bottom-left corner arc.
        path.addLine(to: CGPoint(x: cr, y: h))
        path.addArc(center: CGPoint(x: cr, y: h - cr),
                    radius: cr,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        // Left edge protrusion
        path.addLine(to: CGPoint(x: 0, y: h/2 + ar))
        
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h/2 - ar),
            control: CGPoint(x: -pDepth, y: h/2)
        )
        
        // Top-left corner arc.
        path.addLine(to: CGPoint(x: 0, y: cr))
        
        path.closeSubpath()
        return path
    }
}




