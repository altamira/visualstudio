CREATE TABLE [dbo].[Termo_Garantia] (
    [cd_termo_garantia] INT          NOT NULL,
    [nm_termo_garantia] VARCHAR (30) NOT NULL,
    [sg_termo_garantia] CHAR (10)    NOT NULL,
    [ds_termo_garantia] TEXT         NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    CONSTRAINT [PK_Termo_Garantia] PRIMARY KEY CLUSTERED ([cd_termo_garantia] ASC) WITH (FILLFACTOR = 90)
);

