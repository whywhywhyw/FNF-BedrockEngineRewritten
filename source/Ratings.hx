package;

class Ratings
{
	public static var ratingStuff:Array<Dynamic> = [
		["D", 0.401], // 40%
		["C", 0.7], // 69%
		["B", 0.8], // 79%
		["A", 0.9], // 89%
		["A+", 0.951], // 95%
		["S", 0.976], // 97.5%
		["S+", 1], // 99%
		["SS", 1] // 100%
	];

	public static var ratingComplex:Array<Dynamic> = [
		["D--", 0.2], // %19
		["D-", 0.3], // %29
		["D", 0.401], // %40
		["C-", 0.5], // %49
		["C", 0.6], // %59
		["C", 0.7], // %69
		["B", 0.8], // %79
		["A", 0.86], // %85
		["A.", 0.9], // %89
		["A:", 0.96], // %95
		["AA", 0.976], // %97.5
		["AA.", 0.981], // %98
		["AA:", 0.986], // %98.5
		["AAA", 0.991], // %99
		["AAA.", 0.9936], // %99.35
		["AAA:", 0.9959], // %99.58
		["AAAA", 0.998], // %99.79
		["AAAA.", 0.9989], // %99.88
		["AAAA:", 0.9998], // %99.97
		["S", 1], // %99.99
		["S+", 1] // %100
		// will be used later
	];

	public static var ratingSimple:Array<Dynamic> = [
		["You Suck!", 0.001], // 0%
		["Shit", 0.2], // 19%
		["Bad", 0.4], // 39%
		["Eh", 0.6], // 59%
		["Okay", 0.69], // 68%
		["Nice", 0.691], // 69%
		["Cool", 0.8], // 79%
		["Great!", 0.9], // 89%
		["Sick!", 1], // 99%
		["Perfect!!", 1] // 100%
	];


    public static var errorRating:Array<Dynamic> = [
		["NaN", 1]
	];
}