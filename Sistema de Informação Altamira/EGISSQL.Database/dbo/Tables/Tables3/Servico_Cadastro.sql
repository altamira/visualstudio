CREATE TABLE [dbo].[Servico_Cadastro] (
    [cd_servico_cidade]           INT          NOT NULL,
    [cd_servico]                  INT          NULL,
    [cd_estado]                   INT          NULL,
    [cd_cidade]                   INT          NULL,
    [cd_imposto]                  INT          NULL,
    [cd_dispositivo_legal]        INT          NULL,
    [ic_retencao_imposto_servico] CHAR (1)     NULL,
    [nm_obs_servico_cidade]       VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Servico_Cadastro] PRIMARY KEY CLUSTERED ([cd_servico_cidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Cadastro_Dispositivo_Legal] FOREIGN KEY ([cd_dispositivo_legal]) REFERENCES [dbo].[Dispositivo_Legal] ([cd_dispositivo_legal])
);

