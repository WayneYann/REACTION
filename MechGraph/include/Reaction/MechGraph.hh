/*  FILE     MechGraph.hh
**  PACKAGE  MechGraph
**  AUTHOR   Edward S. Blurock
**
**  CONTENT
**    Definitions for the "MechGraph" package.
**
**  OVERVIEW
**
**  IMPLEMENTATION
**
**  REFERENCES
**
**  COPYRIGHT (C) 1996 Reaction, Edward S. Blurock
*/
 
#ifndef REACTION_MECHGRAPH_HH
#define REACTION_MECHGRAPH_HH
 

/*I  . . . INCLUDES  . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
*/
#include "Basis/GraphCycle.hh"
 
/*C AddMechGraphNode  . . . . .  help to add molecules and reactions to graph
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class AddMechGraphNode
     {
     BasicIdentifyGraph& MGraph;
 public:
     
     AddMechGraphNode(BasicMechanismGraph& mechgraph);

     void operator()(const SimpleMolecule& molecule);
     void operator()(const DbaseReaction& reaction);
     void operator()(const double rate,const DbaseReaction& reaction);
     void PutNodesInGraph(const int id, 
			  const int nodecode,
			  const DbaseReaction& reaction);
     
     };
 

/*C MechanismGraphInfo  . . . . . . . . . . . . . . . .  Info to create graph
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class MechanismGraphInfo : public DBMechanismInfo
     {
 public:
     BasicMechanismGraph MechGraph;
     
     MechanismGraphInfo(int argc, char *argv[])
	  : DBMechanismInfo(argc,argv)
	  {
	  }
     void CreateMechanismGraph(const int mech);
     int FindPathsInMechanism(const int mech, 
			      const Identify& id,
			      String& graphname,
			      String& conditions,
			      const int numiter);
     int StoreMechanismGraphAsProperty(const String& name);
     };
/*C GraphMechRun 
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class GraphMechRun : public ReactionSystemLevel1
     {
 public:
     MechanismGraphInfo MechGraphInfo;
 
     GraphMechRun(int argc, char *argv[])
	  : ReactionSystemLevel1(argc,argv),
	  MechGraphInfo(argc,argv)
	       {
	       Initialize();
	       }
     void Initialize();
     void InitializeGraphMechCommands();
     int Run()
	  {
	  cout << "\n==================================\n";
	  return Commands.ExecuteCommand(0,0,this);
	  }
     
     };
 
/*C ReactionPathEvaluation
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class ReactionPathEvaluation : public ListEvaluationClassesIdentify
{
  PairList<Identify,int> MolCounts;
  PairList<Identify,double> MolWeights;
public:
  ReactionPathEvaluation();
  ReactionPathEvaluation(const ReactionPathEvaluation& path);
  ReactionPathEvaluation(const ObjectList<Identify>& path,
			 PairList<double,DbaseReaction>& selected);

  void FindReactionPathInformation(PairList<double,DbaseReaction>& selected);
  void FindReactionMoleculeInfo(BasicPair<double,DbaseReaction>& rxn);
  void CountMoleculeInfo(bool products,
			 double weight,
			 ObjectList<Identify> mols);
  bool EncodeThis(CommBuffer& buffer);
  bool DecodeThis(CommBuffer& buffer);
  ostream& print(ostream& out) const;
  friend ostream& operator<<(ostream& out,
			     const ReactionPathEvaluation& eval);
  friend bool operator<(const ReactionPathEvaluation& eval1,
			const ReactionPathEvaluation& eval2);
  friend bool operator==(const ReactionPathEvaluation& eval1,
			 const ReactionPathEvaluation& eval2);

};
bool Encode(CommBuffer& buffer, ReactionPathEvaluation& eval);
bool Decode(CommBuffer& buffer, ReactionPathEvaluation& eval);

 
/*C
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class MechGraphFromSenkin : public Identify
{
  double Time;
  double RateCutOff;
  unsigned int MaxRxns;
  bool DrawGraph;

public:
  PairList<double,DbaseReaction> Selected;
  BasicMechanismGraph MechGraph;

  MechGraphFromSenkin(Identify& id,
		      ObjectList<DbaseReaction>& rxns,
		      ObjectList<SimpleMolecule>& mols,
		      MechanismSenkinDataPoints& points,
		      const double time,
		      const double ratecutoff,
		      const unsigned int maxrxns);
  
  ostream& print(ostream& out) const;
  
};

 
/*C PathGraphFromSenkin
**
**  DESCRIPTION
**
**  REMARKS
**
*/
class PathGraphFromSenkin : public Identify
{
  PathSearchConditions Conditions;
  Identify MolID;
  FindPathsInGraph<Identify,Identify> Paths;
  DbaseMechPaths Straight;
  DbaseMechPaths Cycles;
  
public:
  ObjectList<ReactionPathEvaluation> PathEvaluation;
  ObjectList<ReactionPathEvaluation> CycleEvaluation;
  
  PathGraphFromSenkin(Identify& id,
		      const String& molname,
		      MechGraphFromSenkin& mechgraph);
  ostream& print(ostream& out) const; 
};


      
  
/*P  . . . PROTOTYPES  . . . . . . . . . . . . . . . . . . . . . . . . . . . 
*/
int CreateFullMechGraph(ReactionSystemBase *g);
ostream& operator<<(ostream& out, const DbaseMechPaths& paths);
void ReactionPathAnalysis(DbaseMechPaths& paths, 
			  PairList<double,DbaseReaction>& selected,
			  ObjectList<ReactionPathEvaluation>& evals);
ostream& operator<<(ostream& out,
		    const ReactionPathEvaluation& eval);
bool operator<(const ReactionPathEvaluation& eval1,
	       const ReactionPathEvaluation& eval2);
bool operator==(const ReactionPathEvaluation& eval1,
		const ReactionPathEvaluation& eval2);

#endif


