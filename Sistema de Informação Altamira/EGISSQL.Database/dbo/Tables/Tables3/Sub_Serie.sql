CREATE TABLE [dbo].[Sub_Serie] (
    [cd_sub_serie]          INT          NOT NULL,
    [nm_desc_sub_serie]     VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_serie_produto]      INT          NULL,
    [cd_tipo_serie_produto] INT          NULL,
    [nm_sub_serie]          VARCHAR (40) NULL,
    [ic_gera_prog_cnc]      CHAR (1)     NULL,
    [sg_sub_serie]          CHAR (10)    NULL,
    [vl_custo_esquadro]     FLOAT (53)   NULL,
    [cd_serie]              INT          NULL,
    CONSTRAINT [PK_Sub_Serie] PRIMARY KEY CLUSTERED ([cd_sub_serie] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sub_Serie_Tipo_Serie_Produto] FOREIGN KEY ([cd_tipo_serie_produto]) REFERENCES [dbo].[Tipo_Serie_Produto] ([cd_tipo_serie_produto])
);

