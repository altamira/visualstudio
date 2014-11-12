CREATE TABLE [dbo].[Processo_Lembrete] (
    [cd_processo_lembrete]   INT          NOT NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_usuario]             INT          NULL,
    [cd_procedimento]        INT          NULL,
    [ds_ocorrencia_lembrete] TEXT         NULL,
    [ic_gera_ocorrencia]     CHAR (1)     NOT NULL,
    [nm_processo_lembrete]   VARCHAR (40) NULL,
    [cd_modulo]              INT          NULL,
    [cd_tipo_assunto]        INT          NULL,
    [cd_custo_ocorrencia]    INT          NULL,
    CONSTRAINT [PK_Processo_Lembrete] PRIMARY KEY CLUSTERED ([cd_processo_lembrete] ASC) WITH (FILLFACTOR = 90)
);

