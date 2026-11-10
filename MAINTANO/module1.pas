unit module1;
{$mode ObjFPC}{$H+}
interface
uses
  Classes, SysUtils, DB, SQLite3Conn, SQLDB, Forms, Controls, Grids, StdCtrls,
  DBGrids, ExtCtrls, Dialogs, Graphics, ComCtrls, ActnList, FileUtil, DateUtils, dlg_formulaire5;
type
  { TFrameModule1 }
  TFrameModule1 = class(TFrame)
    ActionSupprimeVehicule: TAction;
    ActionModifierVehicule: TAction;
    ActionRefreshVehicule: TAction;
    ActionInsererVoiture: TAction;
    ActionList1: TActionList;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Image1: TImage;
    Splitter1: TSplitter;
    SQLQuery1: TSQLQuery;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure ActionInsererVoitureExecute(Sender: TObject);
    procedure ActionModifierVehiculeExecute(Sender: TObject);
    procedure ActionRefreshVehiculeExecute(Sender: TObject);
    procedure ActionSupprimeVehiculeExecute(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SQLQuery1AfterScroll(DataSet: TDataSet);
  private
    FCache : TStringList; // cache chemin → TBitmap
    function GetImageFromCache(const CheminImage: string): TBitmap;
    function BuildChemin(const NomFichier: string): string;
    procedure ChargerVehiculeDansDialog(dlg : TDlgFormulaire5);
  public
    destructor Destroy; override;
  end;

implementation
uses dlg_formulaire2, Unit1, FPReadJPEG, FPWriteJPEG;
{$R *.lfm}

{ TFrameModule1 }

destructor TFrameModule1.Destroy;
var
  i : integer;
begin
  if FCache <> nil then
  begin
    for i := 0 to FCache.Count - 1 do
      FCache.Objects[i].Free;
    FCache.Free;
  end;
  inherited Destroy;
end;

function TFrameModule1.BuildChemin(const NomFichier: string): string;
var
  N : string;
begin
  N := StringReplace(Trim(NomFichier), '/', PathDelim, [rfReplaceAll]);
  N := StringReplace(N, '\', PathDelim, [rfReplaceAll]);

  Result :=
    IncludeTrailingPathDelimiter(
      ExtractFilePath(Application.ExeName)
    ) +
    'photos' + PathDelim + N;
end;

function TFrameModule1.GetImageFromCache(const CheminImage: string): TBitmap;
var
  Idx : integer;
  MS  : TMemoryStream;
  Pic : TPicture;
begin
  Result := nil;
  if CheminImage = '' then Exit;

  // Initialisation du cache au premier appel
  if FCache = nil then
  begin
    FCache := TStringList.Create;
    FCache.Sorted := True;
  end;

  // Image déjà en cache ?
  Idx := FCache.IndexOf(CheminImage);
  if Idx >= 0 then
  begin
    Result := TBitmap(FCache.Objects[Idx]);
    Exit;
  end;

  if not FileExists(CheminImage) then Exit;

  // Chargement unique depuis le disque → conversion en TBitmap
  MS  := TMemoryStream.Create;
  Pic := TPicture.Create;
  try
    MS.LoadFromFile(CheminImage);
    MS.Position := 0;
    Pic.LoadFromStreamWithFileExt(MS, '.jpg');
    Result := TBitmap.Create;
    Result.Width  := Pic.Width;
    Result.Height := Pic.Height;
    Result.Canvas.Draw(0, 0, Pic.Graphic);
    FCache.AddObject(CheminImage, Result); // stocké en mémoire
  except
    FreeAndNil(Result);
  end;
  Pic.Free;
  MS.Free;
end;

procedure TFrameModule1.SQLQuery1AfterScroll(DataSet: TDataSet);
var
  ChampPhoto  : TField;
  CheminImage : string;
  Bmp         : TBitmap;
begin
  Image1.Picture.Clear;
  if not DataSet.Active or DataSet.IsEmpty then Exit;
  ChampPhoto := DataSet.FindField('photo');
  if (ChampPhoto = nil) or (Trim(ChampPhoto.AsString) = '') then Exit;

  CheminImage := BuildChemin(ChampPhoto.AsString);
  Bmp := GetImageFromCache(CheminImage);
  if Bmp <> nil then
    Image1.Picture.Assign(Bmp);
  Image1.Refresh;
end;

procedure TFrameModule1.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  CheminImage : string;
  Bmp         : TBitmap;
  CarreRect   : TRect;
  Taille      : integer;
  CentreX     : integer;
begin
  if Column.FieldName <> 'photo' then Exit;

  // Fond cellule
  if gdSelected in State then
    DBGrid1.Canvas.Brush.Color := clHighlight
  else
    DBGrid1.Canvas.Brush.Color := clWindow;
  DBGrid1.Canvas.FillRect(Rect);

  if Trim(Column.Field.AsString) = '' then Exit;

  CheminImage := BuildChemin(Column.Field.AsString);

  // Récupère depuis le cache (pas de lecture disque)
  Bmp := GetImageFromCache(CheminImage);
  if Bmp = nil then Exit;

  // Dessin carré centré
  Taille  := Rect.Bottom - Rect.Top;
  CentreX := (Rect.Left + Rect.Right) div 2;
  CarreRect := Classes.Rect(
    CentreX - (Taille div 2),
    Rect.Top,
    CentreX + (Taille div 2),
    Rect.Bottom
  );

  DBGrid1.Canvas.StretchDraw(CarreRect, Bmp);
end;

procedure TFrameModule1.ChargerVehiculeDansDialog(
  dlg : TDlgFormulaire5
);
begin
  dlg.idVehicule :=
    DataSource1.DataSet.FieldByName('id').AsInteger;

  dlg.Immat.Text :=
    DataSource1.DataSet.FieldByName('immat').AsString;

  dlg.Kilometrage.Text :=
    DataSource1.DataSet.FieldByName('kilometrage').AsString;

  dlg.Marque.Text :=
    DataSource1.DataSet.FieldByName('marque').AsString;

  dlg.Modele.Text :=
    DataSource1.DataSet.FieldByName('modele').AsString;

  dlg.Couleur.Text :=
    DataSource1.DataSet.FieldByName('couleur').AsString;

  dlg.Poids.Text :=
    DataSource1.DataSet.FieldByName('poids').AsString;

  dlg.NomPhoto :=
    DataSource1.DataSet.FieldByName('photo').AsString;

  dlg.ChargerImage(dlg.NomPhoto);
end;

procedure TFrameModule1.ActionRefreshVehiculeExecute(Sender: TObject);
begin
     SQLQuery1.Close;
     SQLQuery1.Open;
end;

procedure TFrameModule1.ActionSupprimeVehiculeExecute(Sender: TObject);
var
  idVehicule : Integer;
begin
  idVehicule :=
    DataSource1.DataSet.FieldByName('id').AsInteger;

  if MessageDlg(
    'Supprimer ce véhicule ?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) = mrNo then
    Exit;

  try
  SQLQuery1.Close;

  SQLQuery1.SQL.Text :=
    'DELETE FROM vehicule WHERE id = :id';

  SQLQuery1.ParamByName('id').AsInteger :=
    idVehicule;

  SQLQuery1.ExecSQL;

  Form1.SQLTransaction1.Commit;

  ShowMessage('Véhicule supprimé.');

  SQLQuery1.SQL.Text :=
    'SELECT * FROM vehicule';

  SQLQuery1.Open;

except
  on E: EDatabaseError do
  begin
    Form1.SQLTransaction1.Rollback;

    ShowMessage(
      'Impossible de supprimer ce véhicule car il est utilisé dans un entretien.'
    );

    SQLQuery1.SQL.Text :=
    'SELECT * FROM vehicule';

    SQLQuery1.Open;
    Exit;
  end;

  on E: Exception do
  begin
    Form1.SQLTransaction1.Rollback;

    ShowMessage(E.Message);

    SQLQuery1.SQL.Text :=
    'SELECT * FROM vehicule';

    SQLQuery1.Open;

    Exit;
  end;
end;
end;

procedure TFrameModule1.ActionInsererVoitureExecute(Sender: TObject);
var
  dlg : TDlgFormulaire2;
  r   : Integer;

  km      : Double;
  poids   : Double;

  SourceFile : String;
  DestFile   : String;
  NomPhoto   : String;
begin
  dlg := TDlgFormulaire2.Create(Self);

  try

    repeat
    r := dlg.ShowModal;

    if r <> mrOK then
      Break;

    // =========================
    // Vérifications
    // =========================

    if (Trim(dlg.Immat.Text) = '') or (Trim(dlg.kilometrage.Text) = '') or (Trim(dlg.Photo.Text) = '') or (Trim(dlg.Poids.Text) = '') then
    begin
      ShowMessage('Champ obligatoire vide.');
      Continue;
    end;

    // si tout est bon
    Break;

  until False;

    if r = mrOK then
    begin
      try
        // =========================
        // Vérifications
        // =========================

        if Trim(dlg.Immat.Text) = '' then
        begin
          ShowMessage('Immatriculation obligatoire.');
          Exit;
        end;

        if not TryStrToFloat(Trim(dlg.Kilometrage.Text), km) then
        begin
          ShowMessage('Kilométrage invalide.');
          Exit;
        end;

        if not TryStrToFloat(Trim(dlg.Poids.Text), poids) then
        begin
          ShowMessage('Poids invalide.');
          Exit;
        end;

        // =========================
        // Gestion photo
        // =========================

        if Trim(dlg.Photo.Text) = '' then
        begin
          ShowMessage('Veuillez sélectionner une photo.');
          Exit;
        end;

        SourceFile := Trim(dlg.Photo.Text);

        // Vérifie que le fichier existe
        if not FileExists(SourceFile) then
        begin
          ShowMessage('Le fichier photo est introuvable.');
          Exit;
        end;

        // Création dossier photos
        if not DirectoryExists('photos') then
          CreateDir('photos');

        // Nom du fichier uniquement
        NomPhoto := ExtractFileName(SourceFile);

        // Destination
        DestFile := 'photos\' + NomPhoto;

        // Copie image
        CopyFile(SourceFile, DestFile);

        // =========================
        // Requête SQL
        // =========================

        dlg.SQLQuery1.Close;

        dlg.SQLQuery1.SQL.Text :=
          'INSERT INTO vehicule (' +
          'immat, kilometrage, marque, modele, couleur, poids, photo' +
          ') VALUES (' +
          ':Pimmat, :Pkm, :Pmarque, :Pmodele, :Pcouleur, :Ppoids, :Pphoto' +
          ')';

        // =========================
        // Paramètres
        // =========================

        dlg.SQLQuery1.ParamByName('Pimmat').AsString :=
          Trim(dlg.Immat.Text);

        dlg.SQLQuery1.ParamByName('Pkm').AsFloat :=
          km;

        dlg.SQLQuery1.ParamByName('Pmarque').AsString :=
          Trim(dlg.Marque.Text);

        dlg.SQLQuery1.ParamByName('Pmodele').AsString :=
          Trim(dlg.Modele.Text);

        dlg.SQLQuery1.ParamByName('Pcouleur').AsString :=
          Trim(dlg.Couleur.Text);

        dlg.SQLQuery1.ParamByName('Ppoids').AsFloat :=
          poids;

        // On stocke seulement le nom
        dlg.SQLQuery1.ParamByName('Pphoto').AsString :=
          NomPhoto;

        // =========================
        // Exécution
        // =========================

        dlg.SQLQuery1.ExecSQL;

        Form1.SQLTransaction1.Commit;

        ShowMessage('Véhicule ajouté avec succès.');

      except
        on E: Exception do
        begin
          Form1.SQLTransaction1.Rollback;

          ShowMessage(
            'Erreur lors de l''insertion :' + #13#10 +
            E.Message
          );
        end;
      end;
    end
    else if r = mrRetry then begin
        ActionInsererVoitureExecute(self);
    end

    else
      ShowMessage('Insertion annulée.');
  finally
    dlg.Free;
    ActionRefreshVehiculeExecute(self);
  end;
end;

procedure TFrameModule1.ActionModifierVehiculeExecute(Sender: TObject);
var
  dlg : TDlgFormulaire5;
begin
  dlg := TDlgFormulaire5.Create(Self);

  try
    // =========================
    // PRE-REMPLISSAGE
    // =========================

    ChargerVehiculeDansDialog(dlg);

    // =========================
    // BOUCLE DIALOG
    // =========================

    repeat

      case dlg.ShowModal of

        // =========================
        // OK = UPDATE
        // =========================

        mrOK:
        begin
          try
            SQLQuery1.Close;

            SQLQuery1.SQL.Text :=
              'UPDATE vehicule SET ' +
              'immat = :immat, ' +
              'kilometrage = :km, ' +
              'marque = :marque, ' +
              'modele = :modele, ' +
              'couleur = :couleur, ' +
              'poids = :poids, ' +
              'photo = :photo ' +
              'WHERE id = :id';

            SQLQuery1.ParamByName('immat').AsString :=
              Trim(dlg.Immat.Text);

            SQLQuery1.ParamByName('km').AsFloat :=
              StrToFloat(dlg.Kilometrage.Text);

            SQLQuery1.ParamByName('marque').AsString :=
              Trim(dlg.Marque.Text);

            SQLQuery1.ParamByName('modele').AsString :=
              Trim(dlg.Modele.Text);

            SQLQuery1.ParamByName('couleur').AsString :=
              Trim(dlg.Couleur.Text);

            SQLQuery1.ParamByName('poids').AsFloat :=
              StrToFloat(dlg.Poids.Text);

            SQLQuery1.ParamByName('photo').AsString :=
              dlg.NomPhoto;

            SQLQuery1.ParamByName('id').AsInteger :=
              dlg.idVehicule;

            SQLQuery1.ExecSQL;

            Form1.SQLTransaction1.Commit;

            ShowMessage('Véhicule modifié.');

            Break;

          except
            on E: Exception do
            begin
              Form1.SQLTransaction1.Rollback;

              ShowMessage(
                'Erreur : ' + E.Message
              );
            end;
          end;
        end;

        // =========================
        // RESET
        // =========================

        mrRetry:
        begin
          ChargerVehiculeDansDialog(dlg);
        end;

        // =========================
        // ANNULER
        // =========================

        mrCancel:
        begin
          Break;
        end;

      end;

    until False;

    // =========================
    // REFRESH
    // =========================

    SQLQuery1.Close;

    SQLQuery1.SQL.Text :=
      'SELECT * FROM vehicule';

    SQLQuery1.Open;

  finally
    dlg.Free;
  end;
end;

end.
