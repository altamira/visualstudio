CREATE TABLE [dbo].[Cliente_Cemiterio_Composicao] (
    [cd_cliente_composicao]    INT          NOT NULL,
    [cd_cliente]               INT          NOT NULL,
    [nm_cliente_cemiterio]     VARCHAR (40) NULL,
    [qt_posicao_cli_cemiterio] INT          NULL,
    [dt_nascto_cli_cemiterio]  DATETIME     NULL,
    [dt_falecimento]           DATETIME     NULL,
    [dt_vcto_cli_cemiterio]    DATETIME     NULL,
    [ds_cliente_composicao]    TEXT         NULL,
    [cd_registro_obito]        INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Cemiterio_Composicao] PRIMARY KEY CLUSTERED ([cd_cliente_composicao] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Cemiterio_Composicao_Registro_Obito] FOREIGN KEY ([cd_registro_obito]) REFERENCES [dbo].[Registro_Obito] ([cd_registro_obito])
);

