CREATE TABLE [dbo].[Funcao_Comando] (
    [cd_comando]               INT          NULL,
    [cd_funcao_comando]        INT          NOT NULL,
    [nm_funcao_comando]        VARCHAR (50) NULL,
    [sg_funcao_comando]        CHAR (20)    NULL,
    [cd_funcao_pos]            INT          NULL,
    [ic_verifica_prog_unico]   CHAR (1)     NULL,
    [ic_utiliza_primeiro_prog] CHAR (1)     NULL,
    [ic_utiliza_ultimo_prog]   CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_pos_funcao_comando]    INT          NULL,
    CONSTRAINT [PK_Funcao_Comando] PRIMARY KEY CLUSTERED ([cd_funcao_comando] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcao_Comando_Comando] FOREIGN KEY ([cd_comando]) REFERENCES [dbo].[Comando] ([cd_comando]),
    CONSTRAINT [FK_Funcao_Comando_Funcao_Pos] FOREIGN KEY ([cd_funcao_pos]) REFERENCES [dbo].[Funcao_Pos] ([cd_funcao_pos])
);

