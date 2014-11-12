CREATE TABLE [dbo].[Plano_Especial] (
    [cd_empresa]              INT          NOT NULL,
    [cd_plano_padrao]         INT          NOT NULL,
    [cd_plano_especial]       INT          NOT NULL,
    [nm_conta_plano_especial] VARCHAR (18) NULL,
    [ic_conta_negrito]        CHAR (1)     NOT NULL,
    [ic_numeracao_conta]      CHAR (1)     NOT NULL,
    [ic_assinatura]           CHAR (1)     NOT NULL,
    [ic_conta_sublinhado]     CHAR (1)     NOT NULL,
    [ic_recebe_soma_conta]    CHAR (1)     NOT NULL,
    [ic_data_plano_especial]  CHAR (1)     NOT NULL,
    [ds_plano_especial]       TEXT         NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Plano_especial] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_plano_padrao] ASC, [cd_plano_especial] ASC) WITH (FILLFACTOR = 90)
);

