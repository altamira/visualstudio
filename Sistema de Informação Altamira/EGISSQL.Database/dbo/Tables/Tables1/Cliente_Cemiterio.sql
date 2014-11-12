CREATE TABLE [dbo].[Cliente_Cemiterio] (
    [cd_cliente]         INT          NOT NULL,
    [cd_sexo]            INT          NULL,
    [cd_celular_cliente] VARCHAR (15) NULL,
    [cd_profissao]       INT          NULL,
    [cd_rg_cliente]      VARCHAR (15) NULL,
    [dt_nascto_cliente]  DATETIME     NULL,
    [cd_nacionalidade]   INT          NULL,
    [cd_estado_civil]    INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Cemiterio] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Cemiterio_Estado_Civil] FOREIGN KEY ([cd_estado_civil]) REFERENCES [dbo].[Estado_Civil] ([cd_estado_civil])
);

