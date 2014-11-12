CREATE TABLE [dbo].[Categoria_Viagem] (
    [cd_categoria_viagem]         INT          NOT NULL,
    [nm_categoria_viagem]         VARCHAR (40) NULL,
    [sg_categoria_viagem]         CHAR (10)    NULL,
    [cd_tipo_despesa]             INT          NULL,
    [ic_hotel_categoria]          CHAR (1)     NULL,
    [ic_cia_area_categoria]       CHAR (1)     NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_cotacao_categoria_viagem] CHAR (1)     NULL,
    [ic_pc_categoria_viagem]      CHAR (1)     NULL,
    [ic_orc_categoria_viagem]     CHAR (1)     NULL,
    [ic_servico_categoria]        CHAR (1)     NULL,
    [ic_rv_categoria_viagem]      CHAR (1)     NULL,
    CONSTRAINT [PK_Categoria_Viagem] PRIMARY KEY CLUSTERED ([cd_categoria_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Viagem_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

