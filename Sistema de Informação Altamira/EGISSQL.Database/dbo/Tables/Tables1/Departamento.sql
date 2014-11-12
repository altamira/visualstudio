CREATE TABLE [dbo].[Departamento] (
    [cd_departamento]           INT          NOT NULL,
    [nm_departamento]           VARCHAR (40) NULL,
    [sg_departamento]           CHAR (10)    NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_maquina]                CHAR (1)     NULL,
    [ic_pedido_venda]           CHAR (1)     NULL,
    [ic_pedido_compra]          CHAR (1)     NULL,
    [ic_obrigatorio_maquina]    CHAR (1)     NULL,
    [ic_qualidade_departamento] CHAR (1)     NULL,
    [ic_orcamento_departamento] CHAR (1)     NULL,
    [cd_assunto_viagem]         INT          NULL,
    CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED ([cd_departamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Assunto_Viagem] FOREIGN KEY ([cd_assunto_viagem]) REFERENCES [dbo].[Assunto_Viagem] ([cd_assunto_viagem])
);

