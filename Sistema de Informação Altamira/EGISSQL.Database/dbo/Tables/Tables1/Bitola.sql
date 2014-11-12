CREATE TABLE [dbo].[Bitola] (
    [cd_materia_prima]     INT          NOT NULL,
    [cd_bitola]            INT          NOT NULL,
    [nm_bitola]            VARCHAR (40) NOT NULL,
    [sg_bitola]            CHAR (10)    NOT NULL,
    [qt_bitola]            FLOAT (53)   NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [qt_peso_metro_bitola] FLOAT (53)   NULL,
    [nm_fantasia_bitola]   VARCHAR (15) NULL,
    [cd_ordem_lista_preco] INT          NULL,
    [nm_lista_preco]       VARCHAR (40) NULL,
    CONSTRAINT [PK_Bitola] PRIMARY KEY CLUSTERED ([cd_materia_prima] ASC, [cd_bitola] ASC) WITH (FILLFACTOR = 90)
);

