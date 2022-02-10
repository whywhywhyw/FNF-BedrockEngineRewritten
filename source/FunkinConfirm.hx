package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
 * Confirmation window for FNF
 * Kinda based on @magnumsrtisswag PR to Psych Engine.
 * @author CerBor
 * @author magnumsrtisswag
**/
class FunkinConfirm extends FlxSpriteGroup
{
    private var _bg:FlxSprite;
    private var _title:Alphabet;
    private var _content:FlxText;
    private var _action:FunkinConfirmAction->Void;
    public var isShown(default, set):Bool = false;
    var DEFAULT_TITLE:String = "Title";
    var DEFAULT_CONTENT:String = "swag crap swag shit swag crap";
    public function new(?bg:FlxSprite, ?title:String, ?content:String, ?action:FunkinConfirmAction->Void)
    {
        super(0, 0);
        _title = new Alphabet(0, 0, title == null ? DEFAULT_TITLE : title, true, false, 0, 0.9);
        _content = new FlxText(0, 0, FlxG.width, content == null ? DEFAULT_CONTENT : content);
        _bg = bg != null ? bg : new FlxSprite().makeGraphic(calculateWidth(), calculateHeight(), FlxColor.WHITE);
        if (bg == null)
        {
            _bg.alpha = 0;
            _bg.antialiasing = ClientPrefs.globalAntialiasing;
            _bg.screenCenter();
        }
        add(_bg);
        _title.screenCenter(FlxAxes.X);
        _title.y = _bg.y / 1.2;
        for (i in 0..._title.lettersArray.length)
        { // Small animation
            _title.lettersArray[i].angle = 25;
            _title.lettersArray[i].alpha = 0;
            //_title.lettersArray[i].x += _title.lettersArray[i].width;
        }
        add(_title);
        _content.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        _content.borderSize = 2;
        _content.screenCenter(FlxAxes.X);
        _content.y = _bg.y / 0.8;
        _content.alpha = 0;
        add(_content);

        _action = action != null ? action : (action:FunkinConfirmAction) -> {
            if (action == FunkinConfirmAction.YES_BUTTON_PRESSED) {
                trace ("Yes btn clicked");
            }
            else if (action == FunkinConfirmAction.NO_BUTTON_PRESSED) {
                trace ("No btn clicked");
            }
            else if (action == FunkinConfirmAction.CLOSE) {
                trace ("Window closed");
            }
            hide();
        }
    }

    public override function update(elapsed:Float)
    {
        if (isShown && FlxG.keys.justPressed.Y)
            _action(FunkinConfirmAction.YES_BUTTON_PRESSED);
        else if (isShown && FlxG.keys.justPressed.N)
            _action(FunkinConfirmAction.NO_BUTTON_PRESSED);
        else if (isShown && FlxG.keys.justPressed.C)
            _action(FunkinConfirmAction.CLOSE);
    }

    /**
     * Gets color for dialog background.
    **/
    public function getColor()
    {
        return _bg.color;
    }

    /**
     * Sets color for dialog background.
    **/
    public function setColor(newColor:FlxColor)
    {
        _bg.color = newColor;
        return _bg.color;
    }

    private function set_isShown(newIsShown:Bool)
    {
        isShown = newIsShown;
        return isShown;
    }

    /**
     * Gets dialog title.
    **/
    public function getTitle()
    {
        return _title.text;
    }

    /**
     * Sets dialog title.
    **/
    public function setTitle(newTitle:String)
    {
        _title.changeText(newTitle);
        _title.screenCenter(FlxAxes.X);
        _content.screenCenter(FlxAxes.X);
        _bg.setGraphicSize(calculateWidth(), calculateHeight());
        _bg.screenCenter();
        _title.y = _bg.y / 1.2;
        _content.y = _bg.y / 0.8;
        return _title.text;
    }
    /**
     * Gets dialog text.
    **/
    public function getText()
    {
        return _content.text;
    }

    /**
     * Sets dialog text.
    **/
    public function setText(newText:String)
    {
        _content.text = newText;
        _content.screenCenter(FlxAxes.X);
        _title.screenCenter(FlxAxes.X);
        _bg.setGraphicSize(calculateWidth(), calculateHeight());
        _bg.screenCenter();
        _title.y = _bg.y / 1.2;
        _content.y = _bg.y / 0.8;
        return _content.text;
    }

    /**
     * Get stuff on action (idk why do u need this but okay).
    **/
    public function getAction()
    {
        return _action;
    }

    /**
     * Changes stuff on action.
    **/
    public function setAction(newAction:FunkinConfirmAction->Void)
    {
        _action = newAction;
        return _action;
    }

    /**
     * Shows the dialog.
    **/
    public function show()
    {
        if (_title.lettersArray[_title.lettersArray.length - 1].angle != 25 || isShown)
            return false;
        FlxTween.tween(_bg, {alpha: 0.6}, 1, {ease: FlxEase.sineInOut});
        for (i in 0..._title.lettersArray.length)
        {
            FlxTween.angle(_title.lettersArray[i], 25, 0, 1, {ease: FlxEase.sineInOut, startDelay: i / (_title.lettersArray.length) * 0.7});
            FlxTween.tween(_title.lettersArray[i], {alpha: 1}, 1, {ease: FlxEase.sineInOut, startDelay: i / (_title.lettersArray.length) * 0.7});
        }
        FlxTween.tween(_content, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
        isShown = true;
        return true;
    }

    /**
     * Hides the dialog.
    **/
    public function hide()
    {
        if (_title.lettersArray[_title.lettersArray.length - 1].angle != 0 || !isShown)
            return false;
        FlxTween.tween(_bg, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
        for (i in 0..._title.lettersArray.length)
        {
            FlxTween.angle(_title.lettersArray[i], 0, 25, 1, {ease: FlxEase.sineInOut, startDelay: i / (_title.lettersArray.length) * 0.5});
            FlxTween.tween(_title.lettersArray[i], {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: i / (_title.lettersArray.length) * 0.5});
        }
        FlxTween.tween(_content, {alpha: 0}, 0.7, {ease: FlxEase.sineInOut});
        isShown = false;
        return true;
    }


    /**
     * Calculates width, if you gonna change _bg variable
    **/
    public function calculateWidth()
    {
        if (45 * _title.text.length > 20 * getMaxSymboledLine(_content.text).length)
            return 45 * _title.text.length;
        else
            return Std.int(_content.size / 1.6) * getMaxSymboledLine(_content.text).length;
    }

    /**
     * Calculates height, if you gonna change _bg variable
    **/
    public function calculateHeight()
    {
        return 50 * _content.text.split("\n").length + 100;
    }


    // Needs for auto-calculating dialogue width.
    private function getMaxSymboledLine(str:String)
    {
        var lines = str.split("\n");
        var biggestCount:Int = 0;
        var biggestIndex:Int = 0;
        for (i in 0...lines.length)
            if (lines[i].length > biggestCount) {
                biggestCount = lines[i].length;
                biggestIndex = i;
            }

        return lines[biggestIndex];
    }
}
