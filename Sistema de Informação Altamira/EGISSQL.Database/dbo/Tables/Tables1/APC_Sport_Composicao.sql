CREATE TABLE [dbo].[APC_Sport_Composicao] (
    [cd_composicao]     INT          NOT NULL,
    [cd_conta_sport]    INT          NOT NULL,
    [cd_tipo_conta]     INT          NULL,
    [cd_conta]          INT          NULL,
    [nm_obs_composicao] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_APC_Sport_Composicao] PRIMARY KEY CLUSTERED ([cd_composicao] ASC)
);

