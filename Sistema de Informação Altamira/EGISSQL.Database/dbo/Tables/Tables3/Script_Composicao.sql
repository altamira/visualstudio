CREATE TABLE [dbo].[Script_Composicao] (
    [cd_script]                INT          NOT NULL,
    [cd_item_script]           INT          NOT NULL,
    [cd_script_componente]     INT          NULL,
    [nm_script_composicao]     VARCHAR (40) NULL,
    [cd_ordem_script]          INT          NULL,
    [cd_anterior_script]       INT          NULL,
    [cd_proximo_script]        INT          NULL,
    [nm_obs_script_composicao] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Script_Composicao] PRIMARY KEY CLUSTERED ([cd_script] ASC, [cd_item_script] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Script_Composicao_Script_Componente] FOREIGN KEY ([cd_script_componente]) REFERENCES [dbo].[Script_Componente] ([cd_script_componente])
);

