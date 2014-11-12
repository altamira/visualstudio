CREATE TABLE [dbo].[VE_TipoRecadoSelec] (
    [vers_Recado]        CHAR (11)     NOT NULL,
    [vers_TipoRecadoCod] INT           NOT NULL,
    [vers_DataSituação]  SMALLDATETIME NULL,
    [vers_Usuario]       CHAR (20)     NULL,
    [vers_Observação]    TEXT          NULL,
    CONSTRAINT [PK_VE_TIPORECADOSELEC] PRIMARY KEY NONCLUSTERED ([vers_Recado] ASC, [vers_TipoRecadoCod] ASC) WITH (FILLFACTOR = 90)
);

