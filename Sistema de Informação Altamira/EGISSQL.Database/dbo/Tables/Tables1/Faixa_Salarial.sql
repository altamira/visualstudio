CREATE TABLE [dbo].[Faixa_Salarial] (
    [cd_faixa_salarial] INT          NOT NULL,
    [nm_faixa_salarial] VARCHAR (20) NULL,
    [sg_faixa_salarial] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Faixa_Salarial] PRIMARY KEY CLUSTERED ([cd_faixa_salarial] ASC) WITH (FILLFACTOR = 90)
);

