CREATE TABLE [dbo].[Metodo_Inspecao] (
    [cd_metodo_inspecao] INT          NOT NULL,
    [nm_metodo_inspecao] VARCHAR (40) NULL,
    [nm_fantasia_metodo] VARCHAR (15) NULL,
    [ic_padrao_metodo]   CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Metodo_Inspecao] PRIMARY KEY CLUSTERED ([cd_metodo_inspecao] ASC) WITH (FILLFACTOR = 90)
);

