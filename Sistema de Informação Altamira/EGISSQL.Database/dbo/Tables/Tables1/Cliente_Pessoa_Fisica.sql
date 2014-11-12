CREATE TABLE [dbo].[Cliente_Pessoa_Fisica] (
    [cd_cliente]               INT          NOT NULL,
    [cd_estado_civil]          INT          NULL,
    [cd_nacionalidade]         INT          NULL,
    [cd_cidade]                INT          NULL,
    [cd_profissao]             INT          NULL,
    [nm_profissao_cliente]     VARCHAR (40) NULL,
    [dt_nascimento_cliente]    DATETIME     NULL,
    [nm_pai_cliente]           VARCHAR (60) NULL,
    [nm_mae_cliente]           VARCHAR (60) NULL,
    [ds_cliente_pessoa_fisica] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Pessoa_Fisica] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Pessoa_Fisica_Profissao] FOREIGN KEY ([cd_profissao]) REFERENCES [dbo].[Profissao] ([cd_profissao])
);

