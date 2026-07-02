package funkin.data;

typedef Point2D = {
    var x:Int;
    var y:Int;
}

typedef Bool2D = {
    var x:Bool;
    var y:Bool;
}

typedef AnimationConfig = {
    var animationName:String;
    var fps:Int;
    var prefix:String;
    var ?indices:Array<Int>; // Optional: only needed for frame index mapping
    var offsets:Point2D;
    var ?repeat:Bool; // Optional: can default to false if omitted
}

typedef TextureConfig = {
    var ?library:String; // Optional: defaults to preload/images when omitted
    var path:String;
    var ?blur:Bool; // Optional: sets texture filtering
    var ?skew:Point2D; // Optional: for advanced character rendering
}

typedef CharacterData = {
    var scale:Point2D;
    var flip:Bool2D;
    var texture:TextureConfig;
    var global_offset:Point2D;
    var camera_offset:Point2D;
    var animation_data: {
        var defaultAnim:String;
        var isDancer:Bool;
        var map:Array<AnimationConfig>;
    };
}
