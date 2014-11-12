CREATE TABLE [dbo].[Tipo_NotaFiscal] (
    [cd_notafiscal] INT          NOT NULL,
    [nm_notafiscal] VARCHAR (50) NOT NULL,
    [sg_notafiscal] CHAR (5)     NOT NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tipo_NotaFiscal] PRIMARY KEY CLUSTERED ([cd_notafiscal] ASC) WITH (FILLFACTOR = 90)
);

