unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Generics.Defaults, RegularExpressions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, GBEArray,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo.Types, uPersonne, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.Ani;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Rectangle1: TRectangle;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Rectangle2: TRectangle;
    Memo1: TMemo;
    Button11: TButton;
    Rectangle3: TRectangle;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    procedure initialiserList2;
    { Déclarations privées }
  public
    { Déclarations publiques }
    monTableau: TArray<integer>;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button10Click(Sender: TObject);
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).Concat(TGBEArray<integer>.Create([125, 167, 134, 123, 198]));

  ListBox2.BeginUpdate;
  for var i in GBEArray.ToArray do
    ListBox2.Items.Add(i.toString);
  ListBox2.EndUpdate;
end;

procedure TForm2.Button11Click(Sender: TObject);
begin
  listBox1.Clear;
  ListBox2.Clear;

  if not(memo1.Lines.Text.IsEmpty) then begin
     var sep := ';';
     var GBEArray := TGBEArray<string>.create(TRegEx.Split(lowercase(memo1.Lines.text),'[\s\n\r\W]'))  // Création du TArray<string>  revoir l'expression régulière pour prendre en compte les caractères accentués qui sont pour l'instant considérés comme séparateur de mot...
                                      .map<string>(function(value: string): string  // map pour ajouter un séprateur et un flag à 0 ou à 1 à la valeur
                                           begin
                                             if value.isEmpty then Result := value + sep +'0'
                                             else Result := value + sep + '1';
                                           end)
                                      .filter(function(value: String): Boolean // Filter pour ne conserver que les éléments qui ont 1 après le séparateur
                                              begin
                                                if value.Split(sep)[1] = '0' then result := false
                                                else Result := true;
                                              end)
                                      .gather(function(value, sep: String): String // gather va regrouper les éléments ayant la même clé (le début de la valeur jusqu'au séparateur), et on concatène les valeurs de ces clés
                                              begin
                                                result := value;
                                              end, sep)
                                      .map<string>(function(value: string): string  // map pour faire la somme des valeurs pour chaque clé
                                           begin
                                             var cle := value.Split(sep)[0];
                                             var laValeur := value.Split(sep)[1];
                                             var listeString := TRegEx.Split(laValeur,'[\s]');
                                             var cumul := 0;
                                             for var it in listeString do
                                               inc(cumul, strToIntDef(it,1));
                                             Result := cle + sep + cumul.ToString;
                                           end)
                                      .sort;  // tri alphabétique sur les mots
     for var i in GBEArray.ToArray do
       ListBox2.Items.Add(i);
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);     // Initiaisation d'une liste aléatoire de 20 entiers
begin
  ListBox1.Clear;
  ListBox2.Clear;
  ListBox1.BeginUpdate;
  for var i := 0 to 19 do begin
    ListBox1.Items.Add(random(99).toString);
  end;
  ListBox1.EndUpdate;
end;

procedure TForm2.Button2Click(Sender: TObject);    // Exemple de map qui multiplie par 2 toutes les valeurs des éléments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).map<integer>(
    function(value: integer): integer
    begin
      result := value * 2;
    end);

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilité d'utiliser la méthode print du TGBEArray pour afficher les éléments du tableau de la manière souhaitée
    ListBox2.Items.Add(i.ToString);    // voir l'exemple plus complet avec les TPersonne
  listBox2.EndUpdate;
end;

procedure TForm2.Button3Click(Sender: TObject);    // Exemple de filter qui ne sélectionne que les éléments dont la valeur est > 20
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).filter(
    function(value: integer): boolean
    begin
      result := value > 20;
    end);

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilité d'utiliser la méthode print du TGBEArray pour afficher les éléments du tableau de la manière souhaitée
    ListBox2.Items.Add(i.toString);    // voir l'exemple plus complet avec les TPersonne
  listBox2.EndUpdate;
end;

procedure TForm2.Button4Click(Sender: TObject);  // Exemple de reduce qui réduit le tableau à 1 seul élément la somme de toutes les valeurs des éléments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).reduce<integer>(
    function(valeurPrec, valeur: integer): integer
    begin
      result := valeurPrec + valeur;
    end, 0);

  ListBox2.Items.Add(GBEArray.toString);      // Le reduce ne renvoie qu'un seul élément (pas un nouveau tableau)
end;

procedure TForm2.Button5Click(Sender: TObject);  // Exemple de tri standard des éléments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).sort;

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilité d'utiliser la méthode print du TGBEArray pour afficher les éléments du tableau de la manière souhaitée
    ListBox2.Items.Add(i.toString);    // voir l'exemple plus complet avec les TPersonne
  listBox2.EndUpdate;
end;

procedure TForm2.Button6Click(Sender: TObject);  // exemple enchainant plusieurs traitements sur le tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau)
    .map<integer>(
      function(value: integer): integer
      begin
        result := value * 2;
      end)
    .filter(
      function(value: integer): boolean
      begin
        result := value > 100;
      end)
    .reduce<integer>(
      function(valeurPrec, valeur: integer): integer
      begin
        result := valeurPrec + valeur;
      end, 0);

  ListBox2.Items.Add(GBEArray.toString);
end;

procedure TForm2.Button7Click(Sender: TObject);  // Exemple avec un tableau d'objet de type plus complexe qu'un tableau d'entiers
begin
  listBox1.Clear;
  initialiserList2;

  var listePersonnes := TGBEArray<TPersonne>.Create(              // Création d'une liste de personne
    [TPersonne.Create('Bidochon', 'Robert', TGenre.masculin),
    TPersonne.Create('Durand', 'Françoise', TGenre.feminin),
    TPersonne.Create('Durand', 'Martin', TGenre.nonGenre),
    TPersonne.Create('Dupond', 'Kévin', TGenre.masculin),
    TPersonne.Create('Patoulatchi', 'Bernard', TGenre.nonGenre),
    TPersonne.Create('Durand', 'Alice', TGenre.feminin),
    TPersonne.Create('Bidochon', 'Simone', TGenre.feminin),
    TPersonne.Create('Dupont', 'Gérard', TGenre.masculin),
    TPersonne.Create('Martin', 'Carole', TGenre.feminin),
    TPersonne.Create('Amaury', 'Marie', TGenre.feminin)
    ])
  .Print(function(x: TPersonne): TPersonne
         begin
           var genre := '';
           case x.genre of
             TGenre.masculin: genre := 'Homme';
             TGenre.feminin: genre := 'Femme';
             else genre := 'Aucun';
           end;
           listBox1.Items.Add(x.nom + ' ' + x.prenom + ' '+ genre + ' ' + x.points.ToString+' point'); // Affichage des éléments dans listbox1
           result := X;
         end)
  .Filter(function(x: TPersonne): boolean begin result := x.genre <> TGenre.nonGenre; end)    // on filtre les personnes qui ont un genre
  .map<TPersonne>(function(x: TPersonne): TPersonne begin x.points := random(1000); result := x; end)    // on leur affecte un nombre de points aléatoire
  .sort(TComparer<TPersonne>.Construct(function(const Left: TPersonne; const Right: TPersonne): Integer  // on trie à l'aide d'un TComparer les personnes par ordre décroissant des points obtenus
        begin
          Result := - TComparer<integer>.Default.Compare(Left.points, Right.points);          // on précise donc comment trier sur notre type TPersonne
        end))
  .Print(function(x: TPersonne): TPersonne begin ListBox2.Items.Add(x.nom + ' ' + x.prenom + ' a '+ x.points.ToString+' points'); result := X; end) // Affichage des éléments contenus à cet instant dans listePersonnes
  .Reduce<TPersonne>(    // On réduit listePersonnes à un seul élément en cumulant le nombre de point de chaque élément de listePersonnes
    function(cumul, value : TPersonne): TPersonne
    begin
      value.points := cumul.points + value.points;
      result := value;
    end,
    TPersonne.Create('','',TGenre.nonGenre)
  );

  listbox2.Items.Add('');
  listbox2.Items.Add('Nb total de points distribués : ' + listePersonnes.points.ToString);    // On affiche le nb total de points distribués
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).any(
    function(value: integer): boolean
    begin
      result := value mod 15 = 0;
    end);

  var multiple15 := 'Non';
  if GBEArray then multiple15 := 'Oui';
  ListBox2.Items.Add('Y a t''il un multiple de 15 ? ' + multiple15);
end;

procedure TForm2.Button9Click(Sender: TObject);     // Calcul de la moyenne
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).reduce<integer>(  // On fait la somme totale via le reduce
    function(valeurPrec, valeur: integer): integer
    begin
      result := valeurPrec + valeur;
    end, 0);

  if length(monTableau) > 0 then
    ListBox2.Items.Add((GBEArray/length(monTableau)).toString)  // On divise la somme totale par le nombre d'élément du tableau
  else ListBox2.Items.Add('Pas de moyenne possible');
end;

procedure TForm2.initialiserList2;
begin
  ListBox2.Clear;
  setLength(monTableau, ListBox1.Items.Count);
  for var i := 0 to ListBox1.Items.Count-1 do
    monTableau[i] := StrToInt(ListBox1.Items[i]);
end;

end.
