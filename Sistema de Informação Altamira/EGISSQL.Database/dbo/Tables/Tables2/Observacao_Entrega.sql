CREATE TABLE [dbo].[Observacao_Entrega] (
    [cd_observacao_entrega]       INT          NOT NULL,
    [nm_observacao_entrega]       VARCHAR (30) NULL,
    [sg_observacao_entrega]       CHAR (10)    NOT NULL,
    [ic_fax_observacao_entrega]   CHAR (1)     NOT NULL,
    [ic_email_obs_entrega]        CHAR (1)     NOT NULL,
    [cd_usuario]                  INT          NOT NULL,
    [dt_usuario]                  DATETIME     NOT NULL,
    [ic_ativo_observacao_entrega] CHAR (1)     NULL,
    CONSTRAINT [PK_Observacao_Entrega_Nota_Fiscal] PRIMARY KEY CLUSTERED ([cd_observacao_entrega] ASC) WITH (FILLFACTOR = 90)
);

