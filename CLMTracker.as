package {
    import flash.display.BitmapData;

    public class CLMTracker {

        public var params:Object;

        public var numPatches:int;
        public var patchSize:int;
        public var numParameters:int;
        public var patchType:String;
        public var gaussianPD;
        private var model:Object;
        private var searchWindow:int;
        private var modelWidth:int;
        private var modelHeight:int;



        public function CLMTracker() {
            params = {};
            params.constantVelocity = true;
            params.searchWindow = 11;
            params.scoreThreshold = 0.5;
            params.stopOnConvergence = false;
            params.weightPoints = undefined;
            params.sharpenResponse = false;
        }


        public function init(model:CLMModel):void {
            this.model = model.data;
            patchType = this.model.patchModel.patchType;
            numPatches = parseInt(this.model.patchModel.numPatches);
            patchSize = parseInt(this.model.patchModel.patchSize[0]);

            if (patchType == "MOSSE") {
                searchWindow = patchSize;
            }

            numParameters = parseInt(this.model.shapeModel.numEvalues);
            modelWidth = parseInt(this.model.patchModel.canvasSize[0]);
            modelHeight = parseInt(this.model.patchModel.canvasSize[1]);


        }

        public function start(bitmapData:BitmapData):void {

        }

        public function getCurrentPosition():Array {

        }

        public function getCurrentParameters():Array {

        }
    }
}
