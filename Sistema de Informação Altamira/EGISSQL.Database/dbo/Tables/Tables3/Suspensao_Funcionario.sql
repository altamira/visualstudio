CREATE TABLE [dbo].[Suspensao_Funcionario] (
    [cd_suspensao_funcionario] INT          NOT NULL,
    [nm_suspensao_funcionario] VARCHAR (40) NULL,
    [ds_suspensao_funcionario] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Suspensao_Funcionario] PRIMARY KEY CLUSTERED ([cd_suspensao_funcionario] ASC) WITH (FILLFACTOR = 90)
);

