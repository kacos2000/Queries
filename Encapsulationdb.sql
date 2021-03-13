/* C:\Windows\appcompat\encapsulation\Encapsulation.db */

Select 
ProgramFileHistory.ProgramFileId as 'ProgramFileId',
ProgramFileHistory.ProgramId,
ProgramFileHistory.FileId,
ProgramFileHistory.ExeName,
ProgramFileHistory.FirstSeen,
ProgramFileHistory.LastSeen,
ProgramFileHistoryDetail.CreatedDate,
ProgramFileHistoryDetail.SessionRegistryEventCount,
ProgramFileHistory.TotalRegistryEventCount,
ProgramFileHistoryDetail.RegistryCacheHit,
ProgramFileHistoryDetail.SessionFileEventCount,
ProgramFileHistory.TotalFileEventCount,
ProgramFileHistoryDetail.FileCacheHit,
ProgramFileHistory.LastProcessId,
ProgramFileHistory.DisableLogging

from ProgramFileHistory
join ProgramFileHistoryDetail on ProgramFileHistory.ProgramFileId = ProgramFileHistoryDetail.ProgramFileId
Order by ProgramFileId desc