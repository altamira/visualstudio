CREATE TABLE [dbo].[Operador_Caixa] (
    [cd_operador_caixa]        INT          NOT NULL,
    [nm_operador_caixa]        VARCHAR (40) NULL,
    [nm_fantasia_operador]     VARCHAR (15) NULL,
    [ic_abc_operador_caixa]    CHAR (1)     NULL,
    [ic_fec_operador_caixa]    CHAR (1)     NULL,
    [ic_retira_operador_caixa] CHAR (1)     NULL,
    [cd_senha_operador_caixa]  VARCHAR (15) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario_sistema]       INT          NULL,
    CONSTRAINT [PK_Operador_Caixa] PRIMARY KEY CLUSTERED ([cd_operador_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operador_Caixa_Usuario] FOREIGN KEY ([cd_usuario_sistema]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

