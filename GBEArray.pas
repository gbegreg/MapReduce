{ Developed by Grégory Bersegeay 2022
  https://github.com/gbegreg/MapReduce
  https://www.gbesoft.fr
  https://www.youtube.com/channel/UCmmgsWSi92t51LbWaiyBRkQ
}
unit GBEArray;

interface

uses System.SysUtils, Generics.Collections, system.Generics.Defaults, system.Threading;

type
   TGBEArray<T> = record
     private
       Data: TArray<T>;        // the datas
     public
       class function Create(const Source: TArray<T>): TGBEArray<T>; static; // to feed the datas
       function ToArray: TArray<T>;                                          // convert TGBEArry to TArray
       function Map<S>(Lambda: TFunc<T, S>): TGBEArray<S>;                   // map
       function MapParallel<S>(Lambda: TFunc<T, S>): TGBEArray<S>;           // mapParallel
       function Reduce<S>(Lambda: TFunc<S, T, S>; const Init: S): S;         // reduce
       function Filter(Lambda: TPredicate<T>): TGBEArray<T>;                 // filter
       function Sort(const Comparer: IComparer<T> = nil): TGBEArray<T>;      // sort
       function Print(Lambda: TFunc<T, T>): TGBEArray<T>;                    // print the data
       function Any(Lambda: TPredicate<T>): boolean;                         // any : is there at least one element that corresponds to the request
       function Concat(anArray: TGBEArray<T>): TGBEArray<T>;                 // Concat : concat this TGBEArray<T> with another TGBEArray<T> into a new one
       function Gather(Lambda: TFunc<T,string, string>; sep : string = ';'): TGBEArray<string>; // group the keys/values and return a TGBEArray<string>
       procedure ForEach(Lambda: TProc<T>; fromElement : integer = 0);       // execute lambda for all elements don't return object
       function FirstOrDefault(const Lambda: TPredicate<T> = nil): T;        // Return first element or first element from a predicate (if predicate set) or the default value of T
       function Every(const Lambda: TPredicate<T>): Boolean;                 // Each element respects the lambda
       function FindIndex(Lambda: TPredicate<T>):integer;                    // Return first index of element that match with the predicate
       function Extract(fromElement : integer = 0; toElement : integer = 0): TGBEArray<T>; // Extract element from an TGBEArray from fromElement indice to toElement indice to a new TGBEArray
                                                                                           // if fromElement or toElement are negative, it's indicate an offset from the end of the TGBEArray
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

function TGBEArray<T>.FindIndex(Lambda: TPredicate<T>): integer;
begin
  var indice := -1;
  for var it in self.Data do begin
    inc(indice);
    if Lambda(it) then exit(indice);
  end;
  exit(-1);
end;

procedure TGBEArray<T>.ForEach(Lambda: TProc<T>; fromElement : integer = 0);
begin
  for var it := fromElement to length(self.Data) -1 do
      Lambda(self.Data[it]);
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

function TGBEArray<T>.MapParallel<S>(Lambda: TFunc<T, S>): TGBEArray<S>;
begin
  var ResultArray: TArray<S>;
  var iResultArray := 0;
  SetLength(ResultArray,length(self.Data));
  var anArray := self.Data;

  TParallel.For(0, length(anArray)-1,
    procedure (I:Integer)
    begin
      ResultArray[i] := Lambda(anArray[i]);
    end
  );
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
  result := Init;
  for var it in Self.Data do
    result := Lambda(result, it);
end;

function TGBEArray<T>.ToArray: TArray<T>;
begin
  result := Self.Data;
end;

function TGBEArray<T>.FirstOrDefault(const Lambda: TPredicate<T> = nil): T;
begin
  if assigned(lambda) then begin
    for var X in Self.Data do
      if Lambda(X) then Exit(X);
    Exit(Default(T));
  end else begin
    if (Length(Self.Data) > 0) then Exit(Self.Data[0])
    else Exit(Default(T));
  end;
end;

function TGBEArray<T>.Every(const Lambda: TPredicate<T>): Boolean;
begin
  for var X in Self.Data do
    if not Lambda(X) then
      Exit(False);
  Exit(True);
end;

function TGBEArray<T>.Extract(fromElement : integer = 0; toElement : integer = 0): TGBEArray<T>;
begin
  var ResultArray: TArray<T>;
  var ResultArrayFinalLength := 0;
  SetLength(ResultArray,length(self.Data));
  var start := fromElement;
  if start < 0 then start := length(Self.Data) + start;

  var max := toElement;
  if toElement < 0 then max := length(Self.Data) + max;
  if max < start then max := length(Self.Data) -1;
  if toElement = 0 then max := length(Self.Data) -1;

  for var i := start to max do begin
    ResultArray[ResultArrayFinalLength] := Self.Data[i];
    inc(ResultArrayFinalLength);
  end;

  SetLength(ResultArray,ResultArrayFinalLength);
  result := TGBEArray<T>.Create(ResultArray);
end;

end.
