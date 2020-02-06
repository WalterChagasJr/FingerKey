# FingerKey
Componente criado para captura e verificação da digital do usuário.
O compontente pode ser usado para versão 32 e 64 bits do sistema operacional, bastando setar o target plataforms.</p>

A iniciativa da crição desse componente e encapsular a maioria dos dispositivos de reconhecimento digital que existe no mercado.
Para dá o ponta pé inicial inclui, somente o USB FingKey Hamster (HFDU01/04/06) da NITGEN
O componente têm somente quatro métodos para o seu uso, os métodos são:</p>
</p>
<b>procedure InicializarDispositivo;</b></p>
<b>procedure CapturarDigital;</b></p>
<b>procedure VerificarDigital;</b></p>
<b>property DigitalCapturada:string read  FDigitalCapturada;</b></p>
property IDUsuario:string read FIDUsuario write FIDUsuario;</b></p>
<b>property DigitalCadastrada:string read FDigitalCadastrada write FDigitalCadastrada;</b></p>
</p>
</p>
<b><h1>Exemplo de Capturar Digital</h1></b></p>
procedure TForm1.Button1Click(Sender: TObject);</p>
begin</p>
  try</p>
      FingerKey.IDUsuario:=edtIDUsuario.Text;</p>
      FingerKey.CapturarDigital;</p>
      FDDigitais.Append;</p>
      FDDigitaisIdUsuario.AsString:=edtIDUsuario.Text;</p>
      FDDigitaisDigitalUsuario.AsString:=FingerKey.DigitalCapturada;</p>
      FDDigitais.Post;</p>  
      MessageDlg('Digital cadastrada.', mtInformation, [mbOK],0);</p>     
  except</p>
     on E:Exception do</p>
     begin</p>        
        MessageDlg(e.Message, mtWarning, [mbOK],0);</p>
     end;</p>
  end;</p>
  
<b><h1>Exemplo de Verificar Digital</h1></b></p>
try</p>
    FingerKey.IDUsuario:=FDDigitaisIdUsuario.AsString;</p>
    FingerKey.DigitalCadastrada:=FDDigitaisDigitalUsuario.AsString;</p>
    FingerKey.VerificarDigital;</p>
except</p>
   on E:Exception do</p>
   begin</p>
      MessageDlg(e.Message, mtWarning, [mbOK],0);</p>
   end;</p>
end;</p>

