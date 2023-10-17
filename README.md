# MapReduce
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
![Top language](https://img.shields.io/github/languages/top/gbegreg/MapReduce)
[![](https://tokei.rs/b1/github/gbegreg/MapReduce?category=code)](https://github.com//gbegreg/MapReduce)
[![](https://tokei.rs/b1/github/gbegreg/MapReduce?category=files)](https://github.com//gbegreg/MapReduce)
![GitHub last commit](https://img.shields.io/github/last-commit/gbegreg/MapReduce)

MapReduce with Delphi.

GBEArray is an implementation of MapReduce. It's a generic TArray<T> with some methods :<br /> 
```pascal
function Add(aValue : T): integer;                                    // Add a value to the end of the array and return the new length
function Any(Lambda: TPredicate<T>): boolean;                         // any : is there at least one element that corresponds to the request
function Concat(anArray: TGBEArray<T>): TGBEArray<T>;                 // Concat : concat this TGBEArray<T> with another TGBEArray<T> into a new one
function Every(const Lambda: TPredicate<T>): Boolean;                 // Each element respects the lambda
function Extract(fromElement : integer = 0; toElement : integer = 0): TGBEArray<T>; // Extract element from an TGBEArray from fromElement indice to toElement indice to a new TGBEArray
                                                                                           // if fromElement or toElement are negative, it's indicate an offset from the end of the TGBEArray
function Fill(aValue : T; iStart : integer = 0; iEnd : integer = -1): TGBEArray<T>;       // Fill an TGBEArray<T> with aValue. If the TGBEArray is empty and the iStart at 0, then iEnd parameter specify also the length of the TGBEArray<T>
function Filter(Lambda: TPredicate<T>): TGBEArray<T>;                 // filter
function FilterEvenItems(Lambda: TPredicate<T>): TGBEArray<T>;        // filter on even items only
function FilterOddItems(Lambda: TPredicate<T>): TGBEArray<T>;         // filter on odd items only
function FindIndex(Lambda: TPredicate<T>):integer;                    // Return first index of element that match with the predicate
function FirstOrDefault(const Lambda: TPredicate<T> = nil): T;        // Return first element or first element from a predicate (if predicate set) or the default value of T
procedure ForEach(Lambda: TProc<T>; fromElement : integer = 0; toElement : integer = -1);  // execute lambda for all elements don't return object
function Gather(Lambda: TFunc<T,string, string>; sep : string = ';'): TGBEArray<string>; // group the keys/values and return a TGBEArray<string>
function Insert(aValue : T; index : integer = 0): TGBEArray<T>;       // Insert aValue at index position and return a new TGBEArray
function KeepDuplicates: TGBEArray<T>;                                // Return a new TGBEArray with only duplicates elements
function LastOrDefault(const Lambda: TPredicate<T> = nil): T;         // Return first element or first element from a predicate (if predicate set) or the default value of T
function Map<S>(Lambda: TFunc<T, S>): TGBEArray<S>;                   // map
function MapParallel<S>(Lambda: TFunc<T, S>): TGBEArray<S>;           // mapParallel
function Pop:T;                                                       // return the last item of the array and remove it from the array
function Print(Lambda: TFunc<T, T>): TGBEArray<T>;                    // print the data
function Reduce<S>(Lambda: TFunc<S, T, S>; const Init: S): S;         // reduce
function ReduceRight<S>(Lambda: TFunc<S, T, S>; const Init: S): S;
function Reverse:TGBEArray<T>;                                        // Reverse the array
function Shift: T;                                                    // return the first item of the array and remove it from the array
function Swap(index1, index2 : integer): TGBEArray<T>;                // Return new TGBEArra<T> with swap item1 and item2
function Sort(const Comparer: IComparer<T> = nil): TGBEArray<T>;      // sort
function SuchAs(index : integer; aValue : T): TGBEArray<T>;           // Generate a new Array with the same datas but with aValue at index position
function ToArray: TArray<T>;                                          // convert TGBEArry to TArray
function ToDictionary(iStartKey : integer = 0): TDictionary<integer, T>;  // convert to TDictionary with an optional paramter to specify the start index of key
function ToString(Lambda: TFunc<T, String>; sep : string = ','): String; // convert to string
function Unique(const Comparer: IComparer<T> = nil): TGBEArray<T>;    // Return a new TGBEArray<T> without duplicates
```
  

The project is a sample application to explain how to use it.

In the blue rectangle, you need to click on Initialize button to generate a random dataset of 20 integers. The other buttons in the blue rectangle use this dataset.<br><br>
In the purple rectangle, the click on the button show a sequence of treatments on complex object (TPersonne).<br><br>
Finally, in the yellow rectangle, there is a TMemo where you can write some text. If you click on the button, the process will extract each word and compute for each word its number of occurrences.
 
[![MapReduce](http://img.youtube.com/vi/-KurgNbHmvQ/0.jpg)](https://www.youtube.com/watch?v=-KurgNbHmvQ)

(click the image to see the Youtube video)
