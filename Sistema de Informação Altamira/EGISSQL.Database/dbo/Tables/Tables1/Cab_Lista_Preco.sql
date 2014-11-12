CREATE TABLE [dbo].[Cab_Lista_Preco] (
    [cd_cab_lista_preco]        INT          NOT NULL,
    [nm_cab_lista_preco]        VARCHAR (30) NULL,
    [sg_cab_lista_preco]        CHAR (10)    NULL,
    [cd_mascara_cab_lista_prec] VARCHAR (20) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cab_Lista_Preco] PRIMARY KEY CLUSTERED ([cd_cab_lista_preco] ASC) WITH (FILLFACTOR = 90)
);

