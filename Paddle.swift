import Igis

class Paddle {
    var rectangle : Rectangle
   
    
    init(topLeft:Point, size:Size) {
        print("Created paddles")
        let rect = Rect(topLeft:topLeft, size:size)
        rectangle = Rectangle(rect:rect, fillMode:.fillAndStroke)
    }

    func paint(canvas:Canvas) {
        let strokeStyle = StrokeStyle(color:Color(.black))
        let fillStyle = FillStyle(color:Color(.white))
        let lineWidth = LineWidth(width:2)
        canvas.paint(strokeStyle, fillStyle, lineWidth)
        canvas.paint(rectangle)
    }

    func move(to:Point) {
        rectangle.rect.topLeft = to
    }

}
