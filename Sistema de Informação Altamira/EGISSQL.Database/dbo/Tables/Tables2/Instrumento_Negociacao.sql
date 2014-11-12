CREATE TABLE [dbo].[Instrumento_Negociacao] (
    [cd_instrumento_negociacao] INT          NOT NULL,
    [nm_instrumento_negociacao] VARCHAR (30) NOT NULL,
    [sg_instrumento_negociacao] CHAR (10)    NOT NULL,
    [cd_siscomex]               INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Instrumento_Negociacao] PRIMARY KEY CLUSTERED ([cd_instrumento_negociacao] ASC) WITH (FILLFACTOR = 90)
);

