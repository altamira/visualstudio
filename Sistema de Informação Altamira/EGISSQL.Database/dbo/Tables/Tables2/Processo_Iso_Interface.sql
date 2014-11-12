CREATE TABLE [dbo].[Processo_Iso_Interface] (
    [cd_processo_iso]           INT          NOT NULL,
    [cd_item_processo_iso]      INT          NOT NULL,
    [cd_processo_iso_interface] INT          NOT NULL,
    [nm_obs_process_iso_interf] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Processo_Iso_Interface] PRIMARY KEY CLUSTERED ([cd_processo_iso] ASC, [cd_item_processo_iso] ASC, [cd_processo_iso_interface] ASC) WITH (FILLFACTOR = 90)
);

