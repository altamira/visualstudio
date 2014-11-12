CREATE TABLE [dbo].[APC_Assunto_Fechamento] (
    [cd_fechamento]             INT          NOT NULL,
    [cd_assunto]                INT          NOT NULL,
    [cd_controle]               INT          NOT NULL,
    [ic_fechado_assunto]        CHAR (1)     NULL,
    [nm_obs_assunto_fechamento] VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_APC_Assunto_Fechamento] PRIMARY KEY CLUSTERED ([cd_fechamento] ASC),
    CONSTRAINT [FK_APC_Assunto_Fechamento_APC_Controle_Periodo] FOREIGN KEY ([cd_controle]) REFERENCES [dbo].[APC_Controle_Periodo] ([cd_controle])
);

