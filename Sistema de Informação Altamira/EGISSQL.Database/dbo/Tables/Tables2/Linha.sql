CREATE TABLE [dbo].[Linha] (
    [cd_linha]               INT          NOT NULL,
    [nm_linha]               VARCHAR (30) NOT NULL,
    [ic_linha_ativa]         CHAR (1)     NOT NULL,
    [qt_intervalo_discagem]  INT          NOT NULL,
    [ic_tipo_linha]          CHAR (1)     NOT NULL,
    [nm_prefixo_discagem]    CHAR (10)    NOT NULL,
    [qt_tentativa]           INT          NULL,
    [qt_intervalo_tentativa] INT          NOT NULL,
    [ic_status_linha]        CHAR (1)     NOT NULL,
    [qt_fax_enviados]        INT          NOT NULL,
    [qt_fax_falha]           INT          NULL,
    [qt_rediscagem]          INT          NULL,
    [ds_linha]               TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Linha] PRIMARY KEY CLUSTERED ([cd_linha] ASC) WITH (FILLFACTOR = 90)
);

