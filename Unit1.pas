unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Generics.Defaults, RegularExpressions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, GBEArray,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo.Types, uPersonne, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.Ani, system.Rtti;

type
  TClient = record
    firstname :string;
    lastname: string;
    constructor Create(unNom, unPrenom: string);
  end;

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
    Rectangle4: TRectangle;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Rectangle5: TRectangle;
    Layout2: TLayout;
    Button15: TButton;
    Layout3: TLayout;
    Label1: TLabel;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Layout4: TLayout;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Splitter1: TSplitter;
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
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Layout1Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
  private
    procedure initialiserList2;
    procedure afficherCasTest;
    { D�clarations priv�es }
  public
    { D�clarations publiques }
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
     var GBEArray := TGBEArray<string>.create(TRegEx.Split(lowercase(memo1.Lines.text),'[\s\n\r\W]'))  // Cr�ation du TArray<string>  revoir l'expression r�guli�re pour prendre en compte les caract�res accentu�s qui sont pour l'instant consid�r�s comme s�parateur de mot...
                                      .map<string>(function(value: string): string  // map pour ajouter un s�prateur et un flag � 0 ou � 1 � la valeur
                                           begin
                                             if value.isEmpty then Result := value + sep +'0'
                                             else Result := value + sep + '1';
                                           end)
                                      .filter(function(value: String): Boolean // Filter pour ne conserver que les �l�ments qui ont 1 apr�s le s�parateur
                                              begin
                                                if value.Split(sep)[1] = '0' then result := false
                                                else Result := true;
                                              end)
                                      .gather(function(value, sep: String): String // gather va regrouper les �l�ments ayant la m�me cl� (le d�but de la valeur jusqu'au s�parateur), et on concat�ne les valeurs de ces cl�s
                                              begin
                                                result := value;
                                              end, sep)
                                      .map<string>(function(value: string): string  // map pour faire la somme des valeurs pour chaque cl�
                                           begin
                                             var cle := value.Split(sep)[0];
                                             var laValeur := value.Split(sep)[1];
                                             var listeString := TRegEx.Split(laValeur,'[\s]');
                                             var cumul := 0;
                                             for var it in listeString do
                                               inc(cumul, strToIntDef(it,1));
                                             Result := cle + sep + cumul.ToString;
                                           end)
                                      .sort;  // tri alphab�tique sur les mots
     for var i in GBEArray.ToArray do
       ListBox2.Items.Add(i);
  end;
end;

procedure TForm2.Button12Click(Sender: TObject);
begin
  listBox1.Clear;
  initialiserList2;

  var listePersonnes := TGBEArray<TValue>.Create(     // Cr�ation d'un tableau de TValue
    ['Convert only float value �C to �F', 'Seattle', 16.0, 'Berlin', 15.2, 'Tokyo', 24.2, 'Sydney', 29.5, 'Rio', 34.0, 'Alexandria', 31.4])
  .Print(function(x: TValue): TValue
         begin
           if x.Kind = TTypeKind.tkFloat then listbox1.Items.Add(x.AsExtended.ToString)
           else listBox1.Items.Add(x.AsString);
           result := X;
         end)
  .map<TValue>(function(x: TValue): TValue begin
    if x.Kind = TTypeKind.tkFloat then begin
      x := x.AsExtended * 1.8 + 32; // convert �C to �F
    end;
    result := x;
  end)
  .Print(function(x: TValue): TValue begin
    if x.Kind = TTypeKind.tkFloat then listbox2.Items.Add(x.AsExtended.ToString)
    else ListBox2.Items.Add(x.AsString);
    result := X;
  end)
end;

procedure TForm2.Button13Click(Sender: TObject);
begin
  initialiserList2;

  var GBEArray := TGBEArray<integer>.create(monTableau).Unique(TComparer<integer>.Construct(function(const Left: integer; const Right: integer): Integer
        begin
          Result := TComparer<integer>.Default.Compare(Left, Right);
        end));

  ListBox2.BeginUpdate;
  for var i in GBEArray.ToArray do
    ListBox2.Items.Add(i.toString);
  ListBox2.EndUpdate;
end;

procedure TForm2.Button14Click(Sender: TObject);
begin
  initialiserList2;
  var GBEArrayjoin := TGBEArray<integer>.create(monTableau).Join;
  ListBox2.BeginUpdate;
  ListBox2.Items.Add(GBEArrayjoin);
  ListBox2.EndUpdate;
end;

procedure TForm2.Button15Click(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
  listBox1.Items.Add('Array1 = [1,3,4,5]');
  listBox1.Items.Add('Array2 = [1,2,5,6,7]');
  var tab1 := TGBEArray<Integer>.Create([1,3,4,5]);
  var tab2 := TGBEArray<Integer>.Create([1,2,5,6,7]);

  var resultat := '';
  tab1.Remove(tab2).Print(function(x: integer): integer
         begin
           resultat := resultat + x.ToString + ',';
         end);
  if resultat.EndsWith(',', true) then resultat := copy(resultat, 1, length(resultat) - length(','));
  resultat := 'Array1.remove(Array2) = ['+resultat+']';
  listBox2.Items.Add(resultat);
end;

procedure TForm2.Button16Click(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
  listBox1.Items.Add('Array1 = [1,3,4,5]');
  listBox1.Items.Add('Array2 = [1,2,5,6,7]');
  var tab1 := TGBEArray<Integer>.Create([1,3,4,5]);
  var tab2 := TGBEArray<Integer>.Create([1,2,5,6,7]);

  var resultat := '';
  tab1.IntersectionWith(tab2).Print(function(x: integer): integer
         begin
           resultat := resultat + x.ToString + ',';
         end);
  if resultat.EndsWith(',', true) then resultat := copy(resultat, 1, length(resultat) - length(','));
  resultat := 'Array1.IntersectionWith(Array2) = ['+resultat+']';
  listBox2.Items.Add(resultat);
end;

procedure TForm2.Button17Click(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
  listBox1.Items.Add('Array1 = [1,3,4,5]');
  listBox1.Items.Add('Array2 = [1,2,5,6,7]');
  var tab1 := TGBEArray<Integer>.Create([1,3,4,5]);
  var tab2 := TGBEArray<Integer>.Create([1,2,5,6,7]);

  var resultat := '';
  tab1.SymmetricalDifferenceWith(tab2).Print(function(x: integer): integer
         begin
           resultat := resultat + x.ToString + ',';
         end);
  if resultat.EndsWith(',', true) then resultat := copy(resultat, 1, length(resultat) - length(','));
  resultat := 'Array1.SymmetricalDifferenceWith(Array2) = ['+resultat+']';
  listBox2.Items.Add(resultat);
end;

procedure TForm2.Button18Click(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
  listBox1.Items.Add('Array1 = [1,3,4,5]');
  listBox1.Items.Add('Array2 = [1,2,5,6,7]');
  var tab1 := TGBEArray<Integer>.Create([1,3,4,5]);
  var tab2 := TGBEArray<Integer>.Create([1,2,5,6,7]);

  var resultat := '';
  tab1.UnionWith(tab2).Print(function(x: integer): integer
         begin
           resultat := resultat + x.ToString + ',';
         end);
  if resultat.EndsWith(',', true) then resultat := copy(resultat, 1, length(resultat) - length(','));
  resultat := 'Array1.UnionWith(Array2) = ['+resultat+']';
  listBox2.Items.Add(resultat);
end;

procedure TForm2.Button19Click(Sender: TObject);
begin
  var clients_magasin1 := TGBEArray<TClient>.create(
      [TClient.create('dupond', 'charles'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert')
      ]);

  var clients_magasin2 := TGBEArray<TClient>.create(
      [TClient.create('bertrand', 'marcel'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert'),
      TClient.create('pagnol', 'claire')
      ]);

  afficherCasTest;

  listBox2.Items.Add('clients_store1.remove(clients_store2) = ');
  listBox2.Items.Add('[');

  clients_magasin1.remove(clients_magasin2, function(aValue: TClient): string
                                                     begin
                                                       result := aValue.firstname+','+aValue.lastname;
                                                     end)
                  .Print(function(x: TClient): TClient
                         begin
                           listBox2.Items.Add('   {'+x.firstname + ',' + x.lastname+'}');
                         end);
  listBox2.Items.Add(']');
end;

procedure TForm2.afficherCasTest;
begin
  ListBox1.Clear;
  ListBox2.Clear;
  listBox1.Items.Add('clients_store1 = [');
  listBox1.Items.Add('   {firstname=charles,lastname=dupond},');
  listBox1.Items.Add('   {firstname=marie,lastname=durand},');
  listBox1.Items.Add('   {firstname=robert,lastname=bidochon}');
  listBox1.Items.Add(']');

  listBox1.Items.Add('clients_store2 = [');
  listBox1.Items.Add('   {firstname=marcel,lastname=bertrand},');
  listBox1.Items.Add('   {firstname=marie,lastname=durand},');
  listBox1.Items.Add('   {firstname=robert,lastname=bidochon}');
  listBox1.Items.Add('   {firstname=claire,lastname=pagnol}');
  listBox1.Items.Add(']');
end;

procedure TForm2.Button1Click(Sender: TObject);     // Initiaisation d'une liste al�atoire de 20 entiers
begin
  ListBox1.Clear;
  ListBox2.Clear;
  ListBox1.BeginUpdate;
  for var i := 0 to 19 do begin
    ListBox1.Items.Add(random(99).toString);
  end;
  ListBox1.EndUpdate;
end;

procedure TForm2.Button20Click(Sender: TObject);
begin
  var clients_magasin1 := TGBEArray<TClient>.create(
      [TClient.create('dupond', 'charles'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert')
      ]);

  var clients_magasin2 := TGBEArray<TClient>.create(
      [TClient.create('bertrand', 'marcel'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert'),
      TClient.create('pagnol', 'claire')
      ]);

  afficherCasTest;

  listBox2.Items.Add('clients_store1.IntersectionWith(clients_store2) = ');
  listBox2.Items.Add('[');

  clients_magasin1.IntersectionWith(clients_magasin2, function(aValue: TClient): string
                                                     begin
                                                       result := aValue.firstname+','+aValue.lastname;
                                                     end)
                  .Print(function(x: TClient): TClient
                         begin
                           listBox2.Items.Add('   {'+x.firstname + ',' + x.lastname+'}');
                         end);
  listBox2.Items.Add(']');
end;

procedure TForm2.Button21Click(Sender: TObject);
begin
  var clients_magasin1 := TGBEArray<TClient>.create(
      [TClient.create('dupond', 'charles'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert')
      ]);

  var clients_magasin2 := TGBEArray<TClient>.create(
      [TClient.create('bertrand', 'marcel'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert'),
      TClient.create('pagnol', 'claire')
      ]);

  afficherCasTest;

  listBox2.Items.Add('clients_store1.SymmetricalDifferenceWith(clients_store2) = ');
  listBox2.Items.Add('[');

  clients_magasin1.SymmetricalDifferenceWith(clients_magasin2, function(aValue: TClient): string
                                                     begin
                                                       result := aValue.firstname+','+aValue.lastname;
                                                     end)
                  .Print(function(x: TClient): TClient
                         begin
                           listBox2.Items.Add('   {'+x.firstname + ',' + x.lastname+'}');
                         end);
  listBox2.Items.Add(']');
end;

procedure TForm2.Button22Click(Sender: TObject);
begin
  var clients_magasin1 := TGBEArray<TClient>.create(
      [TClient.create('dupond', 'charles'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert')
      ]);

  var clients_magasin2 := TGBEArray<TClient>.create(
      [TClient.create('bertrand', 'marcel'),
      TClient.create('durand', 'marie'),
      TClient.create('bidochon', 'robert'),
      TClient.create('pagnol', 'claire')
      ]);

  afficherCasTest;

  listBox2.Items.Add('clients_store1.UnionWith(clients_store2) = ');
  listBox2.Items.Add('[');

  clients_magasin1.UnionWith(clients_magasin2, function(aValue: TClient): string
                                                     begin
                                                       result := aValue.firstname+','+aValue.lastname;
                                                     end)
                  .Print(function(x: TClient): TClient
                         begin
                           listBox2.Items.Add('   {'+x.firstname + ',' + x.lastname+'}');
                         end);
  listBox2.Items.Add(']');
end;

procedure TForm2.Button2Click(Sender: TObject);    // Exemple de map qui multiplie par 2 toutes les valeurs des �l�ments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).map<integer>(
    function(value: integer): integer
    begin
      result := value * 2;
    end);

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilit� d'utiliser la m�thode print du TGBEArray pour afficher les �l�ments du tableau de la mani�re souhait�e
    ListBox2.Items.Add(i.ToString);    // voir l'exemple plus complet avec les TPersonne
  listBox2.EndUpdate;
end;

procedure TForm2.Button3Click(Sender: TObject);    // Exemple de filter qui ne s�lectionne que les �l�ments dont la valeur est > 20
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).filter(
    function(value: integer): boolean
    begin
      result := value > 20;
    end);

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilit� d'utiliser la m�thode print du TGBEArray pour afficher les �l�ments du tableau de la mani�re souhait�e
    ListBox2.Items.Add(i.toString);    // voir l'exemple plus complet avec les TPersonne
  listBox2.EndUpdate;
end;

procedure TForm2.Button4Click(Sender: TObject);  // Exemple de reduce qui r�duit le tableau � 1 seul �l�ment la somme de toutes les valeurs des �l�ments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).reduce<integer>(
    function(valeurPrec, valeur: integer): integer
    begin
      result := valeurPrec + valeur;
    end, 0);

  ListBox2.Items.Add(GBEArray.toString);      // Le reduce ne renvoie qu'un seul �l�ment (pas un nouveau tableau)
end;

procedure TForm2.Button5Click(Sender: TObject);  // Exemple de tri standard des �l�ments du tableau
begin
  initialiserList2;
  var GBEArray := TGBEArray<integer>.create(monTableau).sort;

  listBox2.BeginUpdate;
  for var i in GBEArray.ToArray do     // possibilit� d'utiliser la m�thode print du TGBEArray pour afficher les �l�ments du tableau de la mani�re souhait�e
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

  var listePersonnes := TGBEArray<TPersonne>.Create(              // Cr�ation d'une liste de personne
    [TPersonne.Create('Bidochon', 'Robert', TGenre.masculin),
    TPersonne.Create('Durand', 'Fran�oise', TGenre.feminin),
    TPersonne.Create('Durand', 'Martin', TGenre.nonGenre),
    TPersonne.Create('Dupond', 'K�vin', TGenre.masculin),
    TPersonne.Create('Patoulatchi', 'Bernard', TGenre.nonGenre),
    TPersonne.Create('Durand', 'Alice', TGenre.feminin),
    TPersonne.Create('Bidochon', 'Simone', TGenre.feminin),
    TPersonne.Create('Dupont', 'G�rard', TGenre.masculin),
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
           listBox1.Items.Add(x.nom + ' ' + x.prenom + ' '+ genre + ' ' + x.points.ToString+' point'); // Affichage des �l�ments dans listbox1
           result := X;
         end)
  .Filter(function(x: TPersonne): boolean begin result := x.genre <> TGenre.nonGenre; end)    // on filtre les personnes qui ont un genre
  .map<TPersonne>(function(x: TPersonne): TPersonne begin x.points := random(1000); result := x; end)    // on leur affecte un nombre de points al�atoire
  .sort(TComparer<TPersonne>.Construct(function(const Left: TPersonne; const Right: TPersonne): Integer  // on trie � l'aide d'un TComparer les personnes par ordre d�croissant des points obtenus
        begin
          Result := - TComparer<integer>.Default.Compare(Left.points, Right.points);          // on pr�cise donc comment trier sur notre type TPersonne
        end))
  .Print(function(x: TPersonne): TPersonne begin ListBox2.Items.Add(x.nom + ' ' + x.prenom + ' a '+ x.points.ToString+' points'); result := X; end) // Affichage des �l�ments contenus � cet instant dans listePersonnes
  .Reduce<TPersonne>(    // On r�duit listePersonnes � un seul �l�ment en cumulant le nombre de point de chaque �l�ment de listePersonnes
    function(cumul, value : TPersonne): TPersonne
    begin
      value.points := cumul.points + value.points;
      result := value;
    end,
    TPersonne.Create('','',TGenre.nonGenre)
  );

  listbox2.Items.Add('');
  listbox2.Items.Add('Nb total de points distribu�s : ' + listePersonnes.points.ToString);    // On affiche le nb total de points distribu�s

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
    ListBox2.Items.Add((GBEArray/length(monTableau)).toString)  // On divise la somme totale par le nombre d'�l�ment du tableau
  else ListBox2.Items.Add('Pas de moyenne possible');
end;

procedure TForm2.initialiserList2;
begin
  ListBox2.Clear;
  setLength(monTableau, ListBox1.Items.Count);
  for var i := 0 to ListBox1.Items.Count-1 do
    monTableau[i] := StrToInt(ListBox1.Items[i]);
end;

procedure TForm2.Layout1Click(Sender: TObject);
begin

end;

{ TClient }

constructor TClient.Create(unNom, unPrenom: string);
begin
  lastname := unNom;
  firstname := unPrenom;
end;

end.
