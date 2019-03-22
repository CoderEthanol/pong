import Igis
class Ball {
    var ellipse : Ellipse
    var velocityX : Int
    var velocityY: Int
    var pointsR : Int
    var pointsL : Int
    var pointsWin: Bool
    var paddlerLeft : Paddle
    var paddlerRight : Paddle
    
    init(size:Int){
        print("Creating new Ball")
        ellipse = Ellipse(center:Point(x:0, y:0), radiusX:size, radiusY:size, fillMode:.fillAndStroke)
        velocityX = 0
        velocityY = 0
        pointsR = 0
        pointsL = 0
        paddlerLeft = Painter.paddleLeft
        paddlerRight = Painter.paddleRight
        pointsWin = false
    }
    
    func changeVelocity(velocityX:Int, velocityY:Int) {
        self.velocityX = velocityX
        self.velocityY = velocityY
    }

    func calculate(canvasSize:Size) {
        ellipse.center.moveBy(offsetX:velocityX, offsetY:velocityY)
    }
    
    func paint(canvas:Canvas, canvasSize:Size) {
        ellipse.center.moveBy(offsetX:velocityX, offsetY:velocityY)
        let canvasBoundingRect = Rect(topLeft:Point(x:0, y:0), size:canvasSize)
        let ballBoundingRect = Rect(topLeft:Point(x:ellipse.center.x-ellipse.radiusX, y:ellipse.center.y-ellipse.radiusY), size:Size(width:ellipse.radiusX*2, height:ellipse.radiusY*2))
        let tooFarLeft = ballBoundingRect.topLeft.x < canvasBoundingRect.topLeft.x
        let tooFarRight = ballBoundingRect.topLeft.x + ballBoundingRect.size.width > canvasBoundingRect.topLeft.y + canvasBoundingRect.size.width
        let tooFarUp = ballBoundingRect.topLeft.y < canvasBoundingRect.topLeft.y
        let tooFarDown = ballBoundingRect.topLeft.y + ballBoundingRect.size.height > canvasBoundingRect.topLeft.y + canvasBoundingRect.size.height
        
        let paddleLeftBoundingRect = paddlerLeft.rectangle.rect
        let paddleRightBoundingRect = paddlerRight.rectangle.rect
        
        let tooFarLeftPaddle =
          ballBoundingRect.topLeft.x < paddleLeftBoundingRect.topLeft.x + paddleLeftBoundingRect.size.width &&
          ballBoundingRect.topLeft.y + ballBoundingRect.size.height < paddleLeftBoundingRect.topLeft.y + paddleLeftBoundingRect.size.height &&
          ballBoundingRect.topLeft.y > paddleLeftBoundingRect.topLeft.y

        let tooFarRightPaddle =
          ballBoundingRect.topLeft.x + ballBoundingRect.size.width > paddleRightBoundingRect.topLeft.x &&
          ballBoundingRect.topLeft.y + ballBoundingRect.size.height < paddleRightBoundingRect.topLeft.y + paddleRightBoundingRect.size.height &&
          ballBoundingRect.topLeft.y > paddleRightBoundingRect.topLeft.y
                
        if tooFarDown || tooFarUp {
            velocityY = -velocityY
            ellipse.radiusX = ellipse.radiusX+10
            ellipse.radiusY = ellipse.radiusY-5
        }
        if tooFarRight || tooFarLeft || tooFarLeftPaddle || tooFarRightPaddle{
            velocityX = -3*velocityX
            
            ellipse.radiusX = ellipse.radiusX-10
            ellipse.radiusY = ellipse.radiusY+5
        }
        if tooFarRight && pointsR < 9 {
            if pointsL != 9 {
                pointsR = pointsR+1   
            }
        }
        
        if tooFarLeft && pointsL < 9 {
            if pointsR != 9 {
                pointsL = pointsL+1
            }
        }

        let fillStyleB = FillStyle(color:Color(.blue))
        canvas.paint(fillStyleB)
        let textR = Text(location:Point(x:(canvasSize.width/2) - 100, y:100), text:"\(pointsR)", font:"50pt Arial")
        canvas.paint(textR)
        
        if pointsR >= 9 {
            pointsWin = true
        }
        
        
        let fillStyleR = FillStyle(color:Color(.red))
        canvas.paint(fillStyleR)
        let textL = Text(location:Point(x:(canvasSize.width/2) + 100, y:100), text:"\(pointsL)", font:"50pt Arial")
        canvas.paint(textL)

        if pointsL >= 9 {
            pointsWin = true
        }
        
        if pointsWin == true {
            let fillStyleBlack = FillStyle(color:Color(.black))
            canvas.paint(fillStyleBlack)
            let textWin = Text(location:Point(x:(canvasSize.width/2) - 300, y:canvasSize.height/2), text:"Game Over!", font:"100pt Profont")
            canvas.paint(textWin)
            Painter.paddleRight.move(to:Point(x:-100, y:-100))
            Painter.paddleLeft.move(to:Point(x:-100, y:-100))
        }
        
        if !tooFarRight && !tooFarUp && !tooFarDown && !tooFarLeft {
            ellipse.radiusX = 25
            ellipse.radiusY = 25
        }

        let strokeStyle = StrokeStyle(color:Color(.orange))
        let fillStyle = FillStyle(color:Color(.red))
        let lineWidth = LineWidth(width:5)
        canvas.paint(strokeStyle, fillStyle, lineWidth)
        canvas.paint(ellipse)
        
        if velocityX != 10 || velocityX != -10 {
            if velocityX < -10 {
                velocityX += 2
            }
            if velocityX > 10 {
                velocityX -= 2
            }
        }
    }
    func move(to:Point) {
        ellipse.center = to
    }
}
