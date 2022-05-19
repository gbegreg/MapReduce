{ Developed by Grégory Bersegeay 2022
  https://github.com/gbegreg/MapReduce
  https://www.gbesoft.fr
  https://www.youtube.com/channel/UCmmgsWSi92t51LbWaiyBRkQ
}
unit GBEArray;

interface

uses System.SysUtils, Generics.Collections, system.Generics.Defaults;

type
   TGBEArray<T> = record
     private
       Data: TArray<T>;        // the datas
     public
       class function Create(const Source: TArray<T>): TGBEArray<T>; static; // to feed the datas
       function ToArray: TArray<T>;                                          // convert TGBEArry to TArray
       function Map<S>(Lambda: TFunc<T, S>): TGBEArray<S>;                   // map
       function Reduce<S>(Lambda: TFunc<S, T, S>; const Init: S): S;            // reduce
       function Filter(Lambda: TPredicate<T>): TGBEArray<T>;                 // filter
       function Sort(const Comparer: IComparer<T> = nil): TGBEArray<T>;      // sort
       function Print(Lambda: TFunc<T, T>): TGBEArray<T>;                    // print the data
       function Any(Lambda: TPredicate<T>): boolean;                         // any : is there at least one element that corresponds to the request
       function Concat(anArray: TGBEArray<T>): TGBEArray<T>;                 // Concat : concat this TGBEArray<T> with another TGBEArray<T> into a new one
       function Gather(Lambda: TFunc<T,string, string>; sep : string = ';'): TGBEArray<string>; // group the keys/values and return a TGBEArray<string>
   end;

implementation

function TGBEArray<T>.Concat(anArray: TGBEArray<T>): TGBEArray<T>;
begin
  var ResultArray: TArray<T>;
  var iResultArray := 0;
  SetLength(ResultArray, length(self.Data) + length(anArray.Data));
  for var it in Self.Data do begin
      ResultArray[iResultArray] := it;
      inc(iResultArray)
  end;
  for var it in anArray.Data do begin
      ResultArray[iResultArray] := it;
      inc(iResultArray)
  end;
  result := TGBEArray<T>.Create(ResultArray);
end;

class function TGBEArray<T>.Create(const Source: TArray<T>): TGBEArray<T>;
begin
  Result.Data := Source;
end;

function TGBEArray<T>.Filter(Lambda: TPredicate<T>): TGBEArray<T>;
begin
  var ResultArray: TArray<T>;
  var ResultArrayFinalLength := 0;
  SetLength(ResultArray,length(self.Data));
  for var it in Self.Data do begin
    if Lambda(it) then begin
      ResultArray[ResultArrayFinalLength] := it;
      inc(ResultArrayFinalLength);
    end;
  end;
  SetLength(ResultArray,ResultArrayFinalLength);
  result := TGBEArray<T>.Create(ResultArray);
end;

function TGBEArray<T>.Gather(Lambda: TFunc<T, string, string>; sep : string = ';'): TGBEArray<string>;
begin
  var aDico := TDictionary<String,String>.create;
  var ResultArray: TArray<string>;
  SetLength(ResultArray,length(self.Data));

  var iResultArray := 0;
  for var it in self.Data do begin
      ResultArray[iResultArray] := Lambda(it, sep);
      inc(iResultArray);
  end;

  var valeurExistante := '';
  for var it in ResultArray do begin
    var cle := it.Substring(0,pos(sep,it)-1);
    var valeur := it.Substring(pos(sep,it));
    if aDico.TryGetValue(cle,valeurExistante) then
      aDico.AddOrSetValue(cle, valeurExistante+' '+valeur)
    else aDico.Add(cle, valeur);
  end;

  SetLength(ResultArray, aDico.Count);
  iResultArray := 0;
  for var it in aDico.Keys do begin
      ResultArray[iResultArray] := it + sep + aDico.Items[it];
      inc(iResultArray);
  end;

  result := TGBEArray<string>.Create(ResultArray);
end;

function TGBEArray<T>.Map<S>(Lambda: TFunc<T, S>): TGBEArray<S>;
begin
  var ResultArray: TArray<S>;
  var iResultArray := 0;
  SetLength(ResultArray,length(self.Data));
  for var it in self.Data do begin
      ResultArray[iResultArray] := Lambda(it);
      inc(iResultArray);
  end;
  result := TGBEArray<S>.Create(ResultArray);
end;

function TGBEArray<T>.Print(Lambda: TFunc<T, T>): TGBEArray<T>;
begin
  for var it: T in self.Data do
      Lambda(it);
  result := TGBEArray<T>(self.Data);
end;

function TGBEArray<T>.Any(Lambda: TPredicate<T>): boolean;
begin
  for var it in Self.Data do
    if Lambda(it) then Exit(True);
  Exit(False);
end;

function TGBEArray<T>.Sort(const Comparer: IComparer<T> = nil): TGBEArray<T>;
begin
  var ResultArray : TArray<T> := Copy(Self.Data);
  if assigned(Comparer) then TArray.Sort<T>(ResultArray, Comparer)
  else TArray.Sort<T>(ResultArray);
  Result := TGBEArray<T>.Create(ResultArray);
end;

function TGBEArray<T>.Reduce<S>(Lambda: TFunc<S, T, S>; const Init: S): S;
begin
  var cumul := Init;
  for var it in Self.Data do
    cumul := Lambda(cumul, it);
  result := cumul;
end;

function TGBEArray<T>.ToArray: TArray<T>;
begin
  result := Self.Data;
end;

end.
