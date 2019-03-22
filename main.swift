import Foundation
import Igis

class Painter : PainterBase {

    let sky : Image
    static let paddleLeft = Paddle(topLeft:Point(x:0, y:0), size:Size(width:10, height:100))
    static let paddleRight = Paddle(topLeft:Point(x:0, y:0), size:Size(width:10, height:100))
    static let ball = Ball(size:30)
    var coordinatesSet = false
    var canvasRight : Int
           
    required init() {
        Painter.ball.changeVelocity(velocityX:20, velocityY:10)
        guard let skyURL = URL(string:"https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fcms-assets.tutsplus.com%2Flegacy-premium-tutorials%2Fposts%2F25462%2Fimages%2F25462_1dc55ffa06e810d0b8a14a0028787e6f.png&f=1") else {
            fatalError("Failed to create URL for sky")
        }
        sky = Image(sourceURL:skyURL)

        canvasRight = 4200000000
    }
    
    func clearScreen(canvas:Canvas, canvasSize:Size) {
        let rect = Rect(topLeft:Point(x:0, y:0), size:canvasSize)
        let rectangle = Rectangle(rect:rect, fillMode:.clear)
        canvas.paint(rectangle)
    }

    var locationYLeft = 450
    var locationYRight = 450
    
    override func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        let Key = key
        if Key == "s" {
            locationYLeft = locationYLeft + 50
            Painter.paddleLeft.move(to:Point(x:10, y:locationYLeft))
        }
        if Key == "w" {
            locationYLeft = locationYLeft - 50
            Painter.paddleLeft.move(to:Point(x:10, y:locationYLeft))
        }
        if Key == "p" {
            locationYRight = locationYRight - 50
            Painter.paddleRight.move(to:Point(x:canvasRight, y:locationYRight))
        }
        if Key == "l" {
            locationYRight = locationYRight + 50
            Painter.paddleRight.move(to:Point(x:canvasRight, y:locationYRight))
        }
    }

    override func setup(canvas:Canvas) {
        canvas.setup(sky)
        let strokeStyle = StrokeStyle(color:Color(.orange))
        let fillStyle = FillStyle(color:Color(.red))
        let lineWidth = LineWidth(width:5)
        canvas.paint(strokeStyle, fillStyle, lineWidth)
    }

    func calculate(canvasSize:Size) {
        if !coordinatesSet {
            let canvasCenter = Point(x:canvasSize.width/2, y:canvasSize.height/2)
            Painter.ball.move(to:canvasCenter)

            canvasRight = canvasSize.width-20
            Painter.paddleLeft.move(to:Point(x:10, y:canvasCenter.y))
            Painter.paddleRight.move(to:Point(x:canvasRight, y:canvasCenter.y))
                        
            coordinatesSet = true
        }
    }

    func paint(canvas:Canvas, canvasSize:Size) {
        clearScreen(canvas:canvas, canvasSize:canvasSize)
        if sky.isReady {
            sky.renderMode = .destinationRect(Rect(topLeft:Point(x:0, y:0), size:canvas.canvasSize!))
            canvas.paint(sky)
        }
        Painter.ball.paint(canvas:canvas, canvasSize:canvasSize)
        Painter.paddleLeft.paint(canvas:canvas)
        Painter.paddleRight.paint(canvas:canvas)
    }

    override func update(canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            Painter.ball.calculate(canvasSize:canvasSize)
            calculate(canvasSize:canvasSize)
            paint(canvas:canvas, canvasSize:canvasSize)
        }
    }

    override func onClick(location:Point) {
        Painter.ball.move(to:location)
    }
}

print("Starting...")
do {
    let igis = Igis()
    try igis.run(painterType:Painter.self)
} catch (let error) {
    print("Error: \(error)")
}

