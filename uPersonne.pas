unit uPersonne;

interface

type
  TGenre = (masculin, feminin, nonGenre);
  TPersonne = record
  public
    var
      nom, prenom: string;
      points: Integer;
      genre: TGenre;

    constructor Create(unNom, unPrenom: string; unGenre: TGenre);
  end;

implementation

constructor TPersonne.Create(unNom, unPrenom: string; unGenre: TGenre);
begin
  nom := unNom;
  prenom := unPrenom;
  points := 0;
  genre := unGenre;
end;

end.
