package {
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;

    public class CLMMotionDetection extends Sprite {

        public var emotionClassifier:EmotionClassifier;
        public var emotionModel:EmotionModel;
        public var clmModel:CLMModel;
        public var ctrack:CLMTracker;
        public var video:CameraVideo;


        public function CLMMotionDetection() {
            init();
        }

        private function init():void {
            clmModel = new CLMModel();

            ctrack = new CLMTracker();
            ctrack.init(clmModel);

            emotionModel = new EmotionModel();
            emotionClassifier = new EmotionClassifier();
            emotionClassifier.init(emotionModel.data);
            var emotionData = emotionClassifier.getBlank();

            video = new CameraVideo();
            addChild(video)
        }

        public function start() {
            // start video
            video.play();
            // start tracking
            ctrack.start(video.bitmapData);
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }

        private function enterFrame(e:Event):void {
            if (ctrack.getCurrentPosition()) {
                // check players emotions vs current target emotion
            }
            var cp = ctrack.getCurrentParameters();
            var er = emotionClassifier.meanPredict(cp);
            if (er) {
                updateData(er);
                for (var i = 0;i < er.length;i++) {
                    if (er[i].value > 0.4) {
                        // detect success
                    } else {
                        // detect fail
                    }
                }
            }
        }

        private function updateData(data:Object):void {
            // update
            /*var rects = svg.selectAll("rect")
                    .data(data)
                    .attr("y", function(datum) { return height - y(datum.value); })
                    .attr("height", function(datum) { return y(datum.value); });
            var texts = svg.selectAll("text.labels")
                    .data(data)
                    .attr("y", function(datum) { return height - y(datum.value); })
                    .text(function(datum) { return datum.value.toFixed(1);});*/

            // enter
            //rects.enter().append("svg:rect");
            //texts.enter().append("svg:text");

            // exit
            //rects.exit().remove();
            //texts.exit().remove();
        }

    }
}
