CREATE TABLE [dbo].[SI_Historico] (
    [sihi_Modulo]      CHAR (40)     NULL,
    [sihi_Sistema]     CHAR (40)     NULL,
    [sihi_Campo]       CHAR (40)     NULL,
    [sihi_ValorAntes]  CHAR (80)     NULL,
    [sihi_ValorDepois] CHAR (80)     NULL,
    [sihi_Usuario]     CHAR (20)     NULL,
    [sihi_Data]        SMALLDATETIME NULL,
    [sihi_Hora]        CHAR (12)     NULL
);

