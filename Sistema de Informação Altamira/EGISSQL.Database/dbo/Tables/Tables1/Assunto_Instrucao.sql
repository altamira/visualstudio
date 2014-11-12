CREATE TABLE [dbo].[Assunto_Instrucao] (
    [cd_assunto_instrucao]     INT          NOT NULL,
    [nm_assunto_instrucao]     VARCHAR (60) NULL,
    [ds_assunto_instrucao]     TEXT         NULL,
    [ic_ativo_assunto]         CHAR (1)     NULL,
    [nm_obs_assunto_instrucao] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Assunto_Instrucao] PRIMARY KEY CLUSTERED ([cd_assunto_instrucao] ASC) WITH (FILLFACTOR = 90)
);

