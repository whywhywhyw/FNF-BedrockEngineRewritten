package meta.data;

import sys.io.File;

class Ratings
{
	public static var directory:String = "assets/ratings/";

	public static var bedrockRatings:Array<Dynamic> = [
		 
	];

	public static var foreverRatings:Array<Dynamic> = [
	];

	public static var andromedaRatings:Array<Dynamic> = [ 
	];

	public static var psychRatings:Array<Dynamic> = [
	];

	public static var accurateRatings:Array<Dynamic> = [

	];

    public static var errorRating:Array<Dynamic> = [
		["Error", 1]
	];

	public static function callRating()
	{
		bedrockRatings = [
			File.getContent(directory + 'bedrockRatings.txt')
		];

		foreverRatings = [
			File.getContent(directory + 'foreverRatings.txt')
		];

		andromedaRatings = [
			File.getContent(directory + 'andromedaRatings.txt')
		];

		psychRatings = [
			File.getContent(directory + 'psychRatings.txt')
		];
		
		accurateRatings = [
			File.getContent(directory + 'accurateRatings.txt')
		];
	}
}
