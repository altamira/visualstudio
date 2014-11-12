CREATE TABLE [dbo].[Especie_Produto] (
    [cd_especie_produto] INT          NOT NULL,
    [nm_especie_produto] VARCHAR (60) NOT NULL,
    [sg_especie_produto] CHAR (6)     NULL,
    [cd_instru_norm_srf] CHAR (6)     NOT NULL,
    CONSTRAINT [PK_Especie_Produto] PRIMARY KEY CLUSTERED ([cd_especie_produto] ASC) WITH (FILLFACTOR = 90)
);

