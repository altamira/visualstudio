CREATE TABLE [dbo].[Conta_Nac_Rel_Diario_Repnet] (
    [cd_conta_nac_rel] INT          NOT NULL,
    [nm_conta_nac_rel] VARCHAR (20) NULL,
    [sg_conta_nac_rel] VARCHAR (15) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Conta_Nac_Rel_Diario_Repnet] PRIMARY KEY CLUSTERED ([cd_conta_nac_rel] ASC) WITH (FILLFACTOR = 90)
);

